import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// {@template backup.BackupController}
/// A class that defines methods with side effects related to backup operations.
/// {@endtemplate}
class BackupController {
  /// {@macro backup.BackupController}
  ///
  /// The [dbClient] parameter is required and should be an instance
  /// of [DbClient] that will be used to perform database operations.
  const BackupController({
    required this.dbClient,
    required this.dbConnection,
    required this.packageInfo,
  });

  /// Database client.
  final DbClient dbClient;

  /// Database connection.
  final DbConnection dbConnection;

  /// Package information.
  final PackageInfo packageInfo;

  /// Application name.
  String get appName => packageInfo.appName.toLowerCase();

  /// Application version.
  String get version => packageInfo.version;

  /// Creates backup file with current date in temp directory.
  ///
  /// The backup file name follows the format:
  /// `onepage-v{version}-{date}.backup` (date: YYYYMMDDHHmmss).
  ///
  /// Returns a [File] object representing the created backup file.
  Future<void> createBackupFile() async {
    // Create backup file.
    final tmpDir = await getTemporaryDirectory();
    final now = clock.now();
    final date = DateFormat('yyyyMMddHHmmss').format(now);
    final backupFileName = '$appName-v$version-$date.backup';
    final backupFilePath = p.join(tmpDir.path, backupFileName);
    await dbClient.writeBackupToFile(filePath: backupFilePath);
    final backupFile = File(backupFilePath);

    // Share the backup file.
    final shareXFile = XFile(backupFile.path);
    await SharePlus.instance.share(ShareParams(files: [shareXFile]));
  }

  /// Restores database from a backup file selected by user.
  Future<String?> restoreBackupFile() async {
    // Select backup file.
    final result = await FilePicker.platform.pickFiles();
    final backupFilePath = result?.files.single.path;
    if (backupFilePath == null) {
      return backupFilePath;
    }

    // Restore backup file.
    final validBackupFile = await dbConnection.createValidBackupFile(
      backupFilePath: backupFilePath,
    );
    await dbConnection.restoreBackup(validBackupFile: validBackupFile);
    return validBackupFile.path;
  }
}
