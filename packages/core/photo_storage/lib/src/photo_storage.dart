import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// {@template photo_storage.PhotoStorage}
/// Stores diary photo files in a directory owned by the app.
///
/// Photos are identified by the file name returned from [save].
/// {@endtemplate}
class PhotoStorage {
  /// {@macro photo_storage.PhotoStorage}
  ///
  /// Files are stored in [directory].
  const new({required this.directory});

  /// Name of the photo directory inside the application support directory.
  static const directoryName = 'photos';

  /// Extension of the file being written until the write completes.
  static const _temporaryExtension = '.tmp';

  /// Directory that holds the photo files.
  final Directory directory;

  /// Directory that holds the photos that will replace the current ones.
  ///
  /// It is next to [directory], so the replacement is only a rename.
  Directory get stagingDirectory => Directory('${directory.path}.staging');

  Directory get _previous => Directory('${directory.path}.previous');

  /// Creates a [PhotoStorage] that uses the application support directory.
  ///
  /// Puts the photos back if the app stopped in the middle of
  /// [replaceWithStaged].
  static Future<PhotoStorage> create() async {
    final supportDirectory = await getApplicationSupportDirectory();
    final storage = PhotoStorage(
      directory: Directory(p.join(supportDirectory.path, directoryName)),
    );
    if (!storage.directory.existsSync() && storage._previous.existsSync()) {
      await storage._previous.rename(storage.directory.path);
    }
    return storage;
  }

  /// Returns the file for [fileName].
  File file(String fileName) => File(p.join(directory.path, fileName));

  /// Saves [bytes] as a new photo and returns its file name.
  ///
  /// The photo becomes visible under its final name only after all bytes
  /// are written.
  Future<String> save(Uint8List bytes) async {
    await directory.create(recursive: true);

    final fileName = '${const Uuid().v4()}.jpg';
    final temporaryFile = file('$fileName$_temporaryExtension');
    await temporaryFile.writeAsBytes(bytes, flush: true);
    await temporaryFile.rename(file(fileName).path);
    return fileName;
  }

  /// Deletes the photo named [fileName] if it exists.
  Future<void> delete(String fileName) async {
    final target = file(fileName);
    if (target.existsSync()) {
      await target.delete();
    }
  }

  /// Creates an empty [stagingDirectory].
  Future<void> resetStaging() async {
    await _deleteIfExists(stagingDirectory);
    await stagingDirectory.create(recursive: true);
  }

  /// Replaces all photos with the photos in [stagingDirectory].
  ///
  /// Call [commitReplacement] or [rollbackReplacement] afterwards.
  Future<void> replaceWithStaged() async {
    await _deleteIfExists(_previous);
    if (directory.existsSync()) {
      await directory.rename(_previous.path);
    }
    await stagingDirectory.rename(directory.path);
  }

  /// Removes the photos replaced by [replaceWithStaged].
  Future<void> commitReplacement() => _deleteIfExists(_previous);

  /// Puts back the photos replaced by [replaceWithStaged].
  Future<void> rollbackReplacement() async {
    await _deleteIfExists(directory);
    if (_previous.existsSync()) {
      await _previous.rename(directory.path);
    }
  }

  Future<void> _deleteIfExists(Directory target) async {
    if (target.existsSync()) {
      await target.delete(recursive: true);
    }
  }
}
