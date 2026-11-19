import 'dart:async';

import 'package:device_photos/device_photos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_recovery/photo_recovery.dart';

/// A photo library that offers [option] for the photos to recover, and
/// answers a request for access with [request].
class FakeDevicePhotos extends Fake implements DevicePhotos {
  new({
    this.option = DevicePhotoAccessOption.requestPhotos,
    this.request = DevicePhotoAccessRequest.allowed,
  });

  /// How the app can get access to more of the photos.
  final DevicePhotoAccessOption option;

  /// The answer to a request for access.
  final DevicePhotoAccessRequest request;

  @override
  Future<DevicePhotoAccessOption> accessOption(List<String> ids) async {
    return option;
  }

  @override
  Future<DevicePhotoAccessRequest> requestAccess() async => request;
}

/// A photo recovery that finds no photo to recover, or that keeps running
/// after reporting its first photo when [running] is true.
class FakePhotoRecoveryCommand extends Fake implements PhotoRecoveryCommand {
  new({this.running = false});

  /// Whether a recovery keeps running until the test ends.
  final bool running;

  @override
  Future<int> recoverFromDevice({PhotoRecoveryProgress? onProgress}) async {
    if (!running) {
      return 0;
    }
    onProgress?.call(1, 3);
    return Completer<int>().future;
  }
}
