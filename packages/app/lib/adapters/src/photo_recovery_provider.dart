import 'package:device_photos/device_photos.dart';
import 'package:photo_recovery/photo_recovery.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_client_provider.dart';
import 'diary_provider.dart';
import 'photo_storage_provider.dart';

part 'photo_recovery_provider.g.dart';

/// The completed and total photo counts of a running recovery.
typedef PhotoRecoveryStatus = ({int completed, int total});

/// Provides the photos saved on the device.
@Riverpod(keepAlive: true)
DevicePhotos devicePhotos(Ref ref) => const DevicePhotos();

/// A provider that creates a [PhotoRecoveryCommand] instance.
///
/// {@macro photo_recovery.PhotoRecoveryCommand}
@Riverpod(keepAlive: true)
PhotoRecoveryCommand photoRecoveryCommand(Ref ref) {
  return PhotoRecoveryCommand(
    dbClient: ref.watch(dbClientProvider),
    devicePhotos: ref.watch(devicePhotosProvider),
    photoEncoder: const PhotoEncoder(),
    photoStorage: ref.watch(photoStorageProvider),
  );
}

/// Provides how the app can get access to more of the photos to recover.
@riverpod
Future<DevicePhotoAccessOption> devicePhotoAccessOption(Ref ref) async {
  final images = await ref.watch(externalDiaryImagesProvider.future);
  return ref.watch(devicePhotosProvider).accessOption([
    for (final image in images) image.photoId!,
  ]);
}

/// Recovers photos. The state is the progress of the running recovery.
@Riverpod(keepAlive: true)
class PhotoRecovery extends _$PhotoRecovery {
  PhotoRecoveryCommand get _command => ref.read(photoRecoveryCommandProvider);

  DevicePhotos get _devicePhotos => ref.read(devicePhotosProvider);

  @override
  PhotoRecoveryStatus? build() => null;

  /// Recovers the photos that the device can read.
  Future<void> recoverFromDevice() async {
    if (state != null) {
      return;
    }
    state = (completed: 0, total: 0);
    await _waitForRecovery(
      _command.recoverFromDevice(onProgress: _updateProgress),
    );
  }

  /// Asks the user to allow access to the photos to recover and recovers the
  /// allowed ones.
  ///
  /// Returns the number of recovered photos, or null if the user declines.
  Future<int?> recoverRequested() async {
    if (state != null) {
      return null;
    }
    final images = await ref.read(diaryQueryProvider).getExternalDiaryImages();
    final documents = await _devicePhotos.requestPhotos([
      for (final image in images) image.photoId!,
    ]);
    if (documents == null) {
      return null;
    }
    state = (completed: 0, total: 0);
    return _waitForRecovery(
      _command.recoverDocuments(documents, onProgress: _updateProgress),
    );
  }

  void _updateProgress(int completed, int total) {
    state = (completed: completed, total: total);
  }

  Future<int> _waitForRecovery(Future<int> recovery) async {
    try {
      final recovered = await recovery;
      if (recovered > 0) {
        ref.invalidate(diariesProvider);
      }
      return recovered;
    } finally {
      state = null;
      ref
        ..invalidate(devicePhotoAccessOptionProvider)
        ..invalidate(externalDiaryImagesProvider);
    }
  }
}
