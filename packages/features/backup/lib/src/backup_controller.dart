import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:share_plus/share_plus.dart';

/// Called after each photo is processed.
typedef BackupProgressCallback = void Function(int completed, int total);

/// {@template backup.BackupFile}
/// A backup file selected by the user.
/// {@endtemplate}
class BackupFile {
  /// {@macro backup.BackupFile}
  const new({required this.path, required this.isLegacy});

  /// The path of the backup file.
  final String path;

  /// Whether this is a database-only backup without photos.
  final bool isLegacy;
}

/// {@template backup.BackupController}
/// A class that defines methods with side effects related to backup operations.
/// {@endtemplate}
class BackupController {
  /// {@macro backup.BackupController}
  ///
  /// The [dbClient] parameter is required and should be an instance
  /// of [DbClient] that will be used to perform database operations.
  const new({
    required this.dbClient,
    required this.dbConnection,
    required this.packageInfo,
    required this.photoStorage,
  });

  static const _manifestName = 'manifest.json';
  static const _databaseName = 'onepage.sqlite';
  static const _photosDirectoryName = 'photos';
  static const _formatVersion = 1;
  static const _zipSignature = [0x50, 0x4B, 0x03, 0x04];

  /// Database client.
  final DbClient dbClient;

  /// Database connection.
  final DbConnection dbConnection;

  /// Package information.
  final PackageInfo packageInfo;

  /// Storage for photo files.
  final PhotoStorage photoStorage;

  /// Application name.
  String get appName => packageInfo.appName.toLowerCase();

  /// Application version.
  String get version => packageInfo.version;

  /// Creates a backup file in the temp directory and shares it.
  ///
  /// The backup file name follows the format:
  /// `onepage-v{version}-{date}.backup` (date: YYYYMMDDHHmmss).
  ///
  /// The file is a zip that holds the database and the photos it references.
  Future<void> createBackupFile({BackupProgressCallback? onProgress}) async {
    final tmpDir = await getTemporaryDirectory();
    final now = clock.now();
    final date = DateFormat('yyyyMMddHHmmss').format(now);
    final backupFileName = '$appName-v$version-$date.backup';
    final backupFilePath = p.join(tmpDir.path, backupFileName);

    final workDirectory = await tmpDir.createTemp('backup');
    try {
      final databasePath = p.join(workDirectory.path, _databaseName);
      await dbClient.writeBackupToFile(filePath: databasePath);
      final manifest = File(p.join(workDirectory.path, _manifestName))
        ..writeAsStringSync(jsonEncode({'version': _formatVersion}));

      final encoder = ZipFileEncoder()..create(backupFilePath);
      await encoder.addFile(manifest, _manifestName);
      await encoder.addFile(File(databasePath), _databaseName);
      final fileNames = await dbClient.getDiaryImageFileNames();
      final photos = fileNames
          .where((fileName) => photoStorage.file(fileName).existsSync())
          .toList();
      for (final (index, fileName) in photos.indexed) {
        await encoder.addFile(
          photoStorage.file(fileName),
          '$_photosDirectoryName/$fileName',
        );
        await _reportProgress(onProgress, index + 1, photos.length);
      }
      await encoder.close();
    } finally {
      await workDirectory.delete(recursive: true);
    }

    // Share the backup file.
    final shareXFile = XFile(backupFilePath);
    await SharePlus.instance.share(ShareParams(files: [shareXFile]));
  }

  /// Lets the user select a backup file.
  ///
  /// Returns null if the user cancels.
  Future<BackupFile?> pickBackupFile() async {
    final file = await FilePicker.pickFile();
    final path = file?.path;
    if (path == null) {
      return null;
    }
    return BackupFile(path: path, isLegacy: !await _isZip(path));
  }

  /// Replaces the database and photos with the contents of [backupFile].
  ///
  /// The current data stays in place if [backupFile] is invalid.
  /// [dbClient] is closed before anything is replaced, so the caller must
  /// create a new one afterwards.
  Future<void> restoreBackupFile(
    BackupFile backupFile, {
    BackupProgressCallback? onProgress,
  }) async {
    await photoStorage.resetStaging();
    final tmpDir = await getTemporaryDirectory();
    final workDirectory = await tmpDir.createTemp('restore');
    try {
      final databasePath = backupFile.isLegacy
          ? backupFile.path
          : await _extract(backupFile.path, workDirectory.path, onProgress);
      final validBackupFile = await dbConnection.createValidBackupFile(
        backupFilePath: databasePath,
      );

      await dbClient.close();
      await photoStorage.replaceWithStaged();
      try {
        await dbConnection.restoreBackup(validBackupFile: validBackupFile);
      } on Object {
        await photoStorage.rollbackReplacement();
        rethrow;
      }
      await photoStorage.commitReplacement();
    } finally {
      await workDirectory.delete(recursive: true);
    }
  }

  Future<bool> _isZip(String path) async {
    final file = await File(path).open();
    try {
      final signature = await file.read(_zipSignature.length);
      return signature.length == _zipSignature.length &&
          [
            for (var i = 0; i < signature.length; i++)
              signature[i] == _zipSignature[i],
          ].every((matches) => matches);
    } finally {
      await file.close();
    }
  }

  /// Extracts [path] and returns the path of the extracted database.
  ///
  /// Photos are extracted to the staging directory of [photoStorage].
  Future<String> _extract(
    String path,
    String outputDirectory,
    BackupProgressCallback? onProgress,
  ) async {
    final databasePath = p.join(outputDirectory, _databaseName);
    final input = InputFileStream(path);
    try {
      final archive = ZipDecoder().decodeStream(input);

      final manifest = archive.findFile(_manifestName);
      final content = manifest?.readBytes();
      if (content == null) {
        throw const FormatException('The backup has no manifest.');
      }
      final data = jsonDecode(utf8.decode(content)) as Map<String, dynamic>;
      if (data['version'] != _formatVersion) {
        throw const FormatException('Unsupported backup version.');
      }

      final database = archive.findFile(_databaseName);
      if (database == null) {
        throw const FormatException('The backup has no database.');
      }
      _writeFile(database, databasePath);

      final photos = archive.files
          .where(
            (file) =>
                file.isFile && p.url.dirname(file.name) == _photosDirectoryName,
          )
          .toList();
      for (final (index, photo) in photos.indexed) {
        _writeFile(
          photo,
          p.join(
            photoStorage.stagingDirectory.path,
            p.url.basename(photo.name),
          ),
        );
        await _reportProgress(onProgress, index + 1, photos.length);
      }
    } finally {
      await input.close();
    }
    return databasePath;
  }

  /// Reports the progress and yields so that the screen can update.
  Future<void> _reportProgress(
    BackupProgressCallback? onProgress,
    int completed,
    int total,
  ) async {
    onProgress?.call(completed, total);
    await Future<void>.delayed(Duration.zero);
  }

  void _writeFile(ArchiveFile file, String path) {
    final output = OutputFileStream(path);
    file.writeContent(output);
    output.closeSync();
  }
}
