import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

/// Access the app has to the photos on the device.
enum DevicePhotoAccess {
  /// All photos can be read.
  full,

  /// Only the photos the user selected can be read.
  limited,

  /// No photos can be read.
  denied,
}

/// How the app can get access to more photos.
enum DevicePhotoAccessOption {
  /// The user selects a folder that holds the photos.
  selectFolder,

  /// The user allows access in Settings.
  openSettings,

  /// The app already has all the access it can get.
  none,
}

/// What happened when the app asked for access to the photo library.
enum DevicePhotoAccessRequest {
  /// The app can read photos.
  allowed,

  /// The user declined in the system dialog.
  declined,

  /// The system did not ask, so the user has to allow access in Settings.
  unavailable,
}

/// {@template device_photos.DevicePhotos}
/// Reads photos saved on the device by their stored photo IDs.
/// {@endtemplate}
class DevicePhotos {
  /// {@macro device_photos.DevicePhotos}
  const new();

  static const _channel = MethodChannel('com.naipaka.device_photos');

  static const _permissionOption = PermissionRequestOption(
    androidPermission: AndroidPermission(
      type: RequestType.image,
      mediaLocation: false,
    ),
  );

  /// First Android version where `MediaStore.getMediaUri` is available.
  static const _firstFolderSdk = 29;

  /// First Android version that needs the media permissions the app removed.
  static const _firstMediaPermissionSdk = 33;

  Future<int?> get _androidSdk async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return null;
    }
    return _channel.invokeMethod<int>('sdkInt');
  }

  /// How the app can get access to more photos, without asking the user.
  Future<DevicePhotoAccessOption> get accessOption async {
    final sdk = await _androidSdk;
    if (sdk != null && sdk >= _firstFolderSdk) {
      return DevicePhotoAccessOption.selectFolder;
    }
    final state = await PhotoManager.getPermissionState(
      requestOption: _permissionOption,
    );
    return state == PermissionState.authorized
        ? DevicePhotoAccessOption.none
        : DevicePhotoAccessOption.openSettings;
  }

  /// The access the app has to the photo library, without asking the user.
  Future<DevicePhotoAccess> get access async {
    final sdk = await _androidSdk;
    if (sdk != null && sdk >= _firstMediaPermissionSdk) {
      return DevicePhotoAccess.denied;
    }
    final state = await PhotoManager.getPermissionState(
      requestOption: _permissionOption,
    );
    return switch (state) {
      PermissionState.authorized => DevicePhotoAccess.full,
      PermissionState.limited => DevicePhotoAccess.limited,
      _ => DevicePhotoAccess.denied,
    };
  }

  /// Asks the user for access to all photos when the system can still ask.
  Future<DevicePhotoAccessRequest> requestAccess() async {
    final sdk = await _androidSdk;
    if (sdk != null && sdk >= _firstMediaPermissionSdk) {
      return DevicePhotoAccessRequest.unavailable;
    }
    final before = await PhotoManager.getPermissionState(
      requestOption: _permissionOption,
    );
    if (before == PermissionState.authorized) {
      return DevicePhotoAccessRequest.allowed;
    }
    // iOS asks only once, and never for all photos after limited access.
    if (sdk == null && before != PermissionState.notDetermined) {
      return DevicePhotoAccessRequest.unavailable;
    }
    final rationaleBefore = sdk != null && await _shouldShowRationale;
    final after = await PhotoManager.requestPermissionExtend(
      requestOption: _permissionOption,
    );
    if (after.hasAccess) {
      return DevicePhotoAccessRequest.allowed;
    }
    // Android shows no rationale before or after a request only when the
    // permission is denied for good, in which case no dialog appeared.
    if (sdk != null && !rationaleBefore && !await _shouldShowRationale) {
      return DevicePhotoAccessRequest.unavailable;
    }
    return DevicePhotoAccessRequest.declined;
  }

  Future<bool> get _shouldShowRationale async {
    final shown = await _channel.invokeMethod<bool>('shouldShowRationale');
    return shown ?? false;
  }

  /// Returns the original file of the photo [id], or null if it can't be read.
  ///
  /// The file may be the user's original, so the caller must not delete it.
  Future<File?> read(String id) async {
    try {
      final asset = await AssetEntity.fromId(id);
      return await asset?.originFile;
    } on PlatformException {
      return null;
    }
  }

  /// Opens the settings page of the app.
  Future<void> openSettings() => PhotoManager.openSetting();

  /// Lets the user select a folder and returns it, or null if they cancel.
  Future<String?> pickFolder() => _channel.invokeMethod<String>('pickFolder');

  /// Returns the documents in [folder] that match [ids], keyed by photo ID.
  Future<Map<String, String>> findInFolder({
    required String folder,
    required List<String> ids,
  }) async {
    final found = await _channel.invokeMapMethod<String, String>(
      'findInFolder',
      {'folder': folder, 'ids': ids},
    );
    return found ?? {};
  }

  /// Returns a temporary copy of [document], which the caller must delete.
  Future<File> copyDocument(String document) async {
    final path = await _channel.invokeMethod<String>('copyDocument', {
      'document': document,
    });
    return File(path!);
  }
}
