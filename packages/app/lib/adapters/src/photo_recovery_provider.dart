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
@riverpod
DevicePhotos devicePhotos(Ref ref) => const DevicePhotos();

/// A provider that creates a [PhotoRecoveryCommand] instance.
///
/// {@macro photo_recovery.PhotoRecoveryCommand}
@riverpod
PhotoRecoveryCommand photoRecoveryCommand(Ref ref) {
  return PhotoRecoveryCommand(
    dbClient: ref.watch(dbClientProvider),
    devicePhotos: ref.watch(devicePhotosProvider),
    photoEncoder: const PhotoEncoder(),
    photoStorage: ref.watch(photoStorageProvider),
  );
}

/// Provides how the app can get access to more photos.
@riverpod
Future<DevicePhotoAccessOption> devicePhotoAccessOption(Ref ref) {
  return ref.watch(devicePhotosProvider).accessOption;
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

  /// Lets the user select a folder and recovers the photos in it.
  ///
  /// Returns the number of recovered photos, or null if the user cancels.
  Future<int?> recoverFromFolder() async {
    if (state != null) {
      return null;
    }
    final folder = await _devicePhotos.pickFolder();
    if (folder == null) {
      return null;
    }
    state = (completed: 0, total: 0);
    return _waitForRecovery(
      _command.recoverFromFolder(folder, onProgress: _updateProgress),
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
