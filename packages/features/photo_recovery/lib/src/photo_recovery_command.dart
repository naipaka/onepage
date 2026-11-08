import 'dart:io';

import 'package:db_client/db_client.dart';
import 'package:device_photos/device_photos.dart';
import 'package:photo_storage/photo_storage.dart';

/// Called after each photo is processed.
typedef PhotoRecoveryProgress = void Function(int completed, int total);

/// {@template photo_recovery.PhotoRecoveryCommand}
/// Copies photos saved on the device into app storage.
///
/// Each photo is committed on its own, so a stopped recovery continues with
/// the photos that remain.
/// {@endtemplate}
class PhotoRecoveryCommand {
  /// {@macro photo_recovery.PhotoRecoveryCommand}
  const new({
    required this.dbClient,
    required this.devicePhotos,
    required this.photoEncoder,
    required this.photoStorage,
  });

  /// Database client.
  final DbClient dbClient;

  /// Photos saved on the device.
  final DevicePhotos devicePhotos;

  /// Encoder that compresses photos.
  final PhotoEncoder photoEncoder;

  /// Storage for photo files.
  final PhotoStorage photoStorage;

  /// Recovers the photos that the device can read.
  ///
  /// Reads with the access the app already has, without asking the user.
  ///
  /// Returns the number of recovered photos.
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) async {
    final images = await dbClient.getExternalDiaryImages();
    if (images.isEmpty) {
      return 0;
    }
    final access = await devicePhotos.access;
    if (access == DevicePhotoAccess.denied) {
      return 0;
    }
    return _recover(
      images,
      onProgress: onProgress,
      recover: (photoId) async {
        final file = await devicePhotos.read(photoId);
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
    final images = await dbClient.getExternalDiaryImages();
    final documents = await devicePhotos.findInFolder(
      folder: folder,
      ids: [for (final image in images) image.photoId!],
    );
    return recoverDocuments(documents, onProgress: onProgress);
  }

  /// Recovers the photos in [documents], which are keyed by photo ID.
  ///
  /// Returns the number of recovered photos.
  Future<int> recoverDocuments(
    Map<String, String> documents, {
    PhotoRecoveryProgress? onProgress,
  }) async {
    final images = await dbClient.getExternalDiaryImages();
    return _recover(
      images,
      onProgress: onProgress,
      recover: (photoId) async {
        final document = documents[photoId];
        if (document == null) {
          return null;
        }
        final copy = await devicePhotos.copyDocument(document);
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
        // One unreadable photo must not stop the others. It keeps its photo
        // data outside the app.
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
