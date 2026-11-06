import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

/// Access the app has to the device photo library.
enum PhotoLibraryAccess {
  /// All photos can be read.
  full,

  /// Only the photos the user selected can be read.
  limited,

  /// No photos can be read.
  denied,
}

/// {@template photo_client.PhotoLibrary}
/// Reads photos saved on the device by their stored photo IDs.
/// {@endtemplate}
class PhotoLibrary {
  /// {@macro photo_client.PhotoLibrary}
  const new();

  static const _channel = MethodChannel('com.naipaka.onepage/photo_library');

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

  /// Whether the user can recover photos by selecting a folder.
  Future<bool> get supportsFolder async {
    final sdk = await _androidSdk;
    return sdk != null && sdk >= _firstFolderSdk;
  }

  /// Requests access to the photo library.
  Future<PhotoLibraryAccess> requestAccess() async {
    final sdk = await _androidSdk;
    if (sdk != null && sdk >= _firstMediaPermissionSdk) {
      return PhotoLibraryAccess.denied;
    }
    final state = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.image,
          mediaLocation: false,
        ),
      ),
    );
    return switch (state) {
      PermissionState.authorized => PhotoLibraryAccess.full,
      PermissionState.limited => PhotoLibraryAccess.limited,
      _ => PhotoLibraryAccess.denied,
    };
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
