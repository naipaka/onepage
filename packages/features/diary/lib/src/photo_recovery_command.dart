import 'dart:io';

import 'package:db_client/db_client.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_storage/photo_storage.dart';

/// Called after each photo is processed.
typedef PhotoRecoveryProgress = void Function(int completed, int total);

/// {@template diary.PhotoRecoveryCommand}
/// Copies photos saved on the device into app storage.
///
/// Each photo is committed on its own, so a stopped recovery continues with
/// the photos that remain.
/// {@endtemplate}
class PhotoRecoveryCommand {
  /// {@macro diary.PhotoRecoveryCommand}
  const new({
    required this.dbClient,
    required this.photoLibrary,
    required this.photoEncoder,
    required this.photoStorage,
  });

  /// Database client.
  final DbClient dbClient;

  /// Device photo library.
  final PhotoLibrary photoLibrary;

  /// Encoder that compresses photos.
  final PhotoEncoder photoEncoder;

  /// Storage for photo files.
  final PhotoStorage photoStorage;

  /// Recovers the photos that the library can read.
  ///
  /// Returns the number of recovered photos.
  Future<int> recoverFromLibrary({PhotoRecoveryProgress? onProgress}) async {
    final images = await dbClient.getUnmigratedDiaryImages();
    return _recover(
      images,
      onProgress: onProgress,
      recover: (photoId) async {
        final file = await photoLibrary.read(photoId);
        if (file == null) {
          return null;
        }
        return _store(file);
      },
    );
  }

  /// Recovers the photos found in [folder].
  ///
  /// Returns the number of recovered photos.
  Future<int> recoverFromFolder(
    String folder, {
    PhotoRecoveryProgress? onProgress,
  }) async {
    final images = await dbClient.getUnmigratedDiaryImages();
    final documents = await photoLibrary.findInFolder(
      folder: folder,
      ids: [for (final image in images) image.photoId!],
    );
    return _recover(
      images,
      onProgress: onProgress,
      recover: (photoId) async {
        final document = documents[photoId];
        if (document == null) {
          return null;
        }
        final copy = await photoLibrary.copyDocument(document);
        try {
          return await _store(copy);
        } finally {
          await copy.delete();
        }
      },
    );
  }

  Future<int> _recover(
    List<DiaryImage> images, {
    required Future<String?> Function(String photoId) recover,
    required PhotoRecoveryProgress? onProgress,
  }) async {
    var recovered = 0;
    for (final (index, image) in images.indexed) {
      try {
        final fileName = await recover(image.photoId!);
        if (fileName != null) {
          await dbClient.setDiaryImageFileName(
            id: image.id,
            fileName: fileName,
          );
          recovered++;
        }
      } on Exception {
        // One unreadable photo must not stop the others. It stays unmigrated.
      }
      onProgress?.call(index + 1, images.length);
    }
    return recovered;
  }

  Future<String> _store(File file) async {
    final encoded = await photoEncoder.encode(file.path);
    return photoStorage.save(encoded);
  }
}
