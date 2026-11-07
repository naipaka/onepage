import 'dart:io';

import 'package:device_photos/device_photos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const _channel = MethodChannel('com.naipaka.device_photos');

class _FakePlugin extends Fake
    with MockPlatformInterfaceMixin
    implements PhotoManagerPlugin {
  PermissionState permission = PermissionState.authorized;
  PermissionState? answer;
  int permissionRequests = 0;
  int settingsOpened = 0;
  File? file;
  Exception? error;

  @override
  Future<PermissionState> requestPermissionExtend(
    PermissionRequestOption requestOption,
  ) async {
    permissionRequests++;
    return answer ?? permission;
  }

  @override
  Future<PermissionState> getPermissionState(
    PermissionRequestOption requestOption,
  ) async => permission;

  @override
  Future<void> openSetting() async => settingsOpened++;

  @override
  Future<Map<dynamic, dynamic>?> fetchEntityProperties(String id) async {
    return id == 'found'
        ? {
            'id': id,
            'type': 1,
            'width': 1,
            'height': 1,
            'duration': 0,
            'orientation': 0,
            'favorite': false,
            'title': 'photo.jpg',
            'modifiedDt': 0,
            'createDt': 0,
          }
        : null;
  }

  @override
  Future<String?> getFullFile(
    String id, {
    required bool isOrigin,
    PMProgressHandler? progressHandler,
    int subtype = 0,
    PMDarwinAVFileType? darwinFileType,
    PMCancelToken? cancelToken,
  }) async {
    if (error case final error?) {
      throw error;
    }
    return file?.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DevicePhotos', () {
    const devicePhotos = DevicePhotos();
    late _FakePlugin plugin;
    late List<MethodCall> calls;
    var sdk = 34;
    Object? channelResult;
    var rationales = <bool>[];

    setUp(() {
      plugin = _FakePlugin();
      PhotoManager.withPlugin(plugin);
      calls = [];
      sdk = 34;
      channelResult = null;
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_channel, (call) async {
            calls.add(call);
            return switch (call.method) {
              'sdkInt' => sdk,
              'shouldShowRationale' => rationales.removeAt(0),
              _ => channelResult,
            };
          });
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_channel, null);
    });

    group('accessOption', () {
      test('is folder selection on Android 10 and later', () async {
        sdk = 29;

        expect(
          await devicePhotos.accessOption,
          DevicePhotoAccessOption.selectFolder,
        );
      });

      test('is nothing with full access before Android 10', () async {
        sdk = 28;

        expect(await devicePhotos.accessOption, DevicePhotoAccessOption.none);
      });

      test('is Settings without full access', () async {
        sdk = 28;
        for (final state in [PermissionState.limited, PermissionState.denied]) {
          plugin.permission = state;

          expect(
            await devicePhotos.accessOption,
            DevicePhotoAccessOption.openSettings,
          );
        }
      });

      test('does not ask the user', () async {
        sdk = 28;

        await devicePhotos.accessOption;

        expect(plugin.permissionRequests, 0);
      });

      test('reads the permission on iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        expect(await devicePhotos.accessOption, DevicePhotoAccessOption.none);
        expect(calls, isEmpty);
      });
    });

    group('access', () {
      test('is denied on Android 13 and later', () async {
        sdk = 33;

        expect(await devicePhotos.access, DevicePhotoAccess.denied);
      });

      test('maps the permission state without asking', () async {
        sdk = 32;
        final expected = {
          PermissionState.authorized: DevicePhotoAccess.full,
          PermissionState.limited: DevicePhotoAccess.limited,
          PermissionState.denied: DevicePhotoAccess.denied,
          PermissionState.restricted: DevicePhotoAccess.denied,
        };

        for (final MapEntry(:key, :value) in expected.entries) {
          plugin.permission = key;

          expect(await devicePhotos.access, value);
        }
        expect(plugin.permissionRequests, 0);
      });
    });

    group('requestAccess', () {
      test('is unavailable on Android 13 and later', () async {
        sdk = 33;

        expect(
          await devicePhotos.requestAccess(),
          DevicePhotoAccessRequest.unavailable,
        );
        expect(plugin.permissionRequests, 0);
      });

      test('does not ask with full access', () async {
        sdk = 32;

        expect(
          await devicePhotos.requestAccess(),
          DevicePhotoAccessRequest.allowed,
        );
        expect(plugin.permissionRequests, 0);
      });

      group('on iOS', () {
        setUp(() {
          debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        });

        test('asks when it has not asked yet', () async {
          plugin
            ..permission = PermissionState.notDetermined
            ..answer = PermissionState.limited;

          expect(
            await devicePhotos.requestAccess(),
            DevicePhotoAccessRequest.allowed,
          );
          expect(plugin.permissionRequests, 1);
        });

        test('reports a declined request', () async {
          plugin
            ..permission = PermissionState.notDetermined
            ..answer = PermissionState.denied;

          expect(
            await devicePhotos.requestAccess(),
            DevicePhotoAccessRequest.declined,
          );
        });

        test('is unavailable after the user answered', () async {
          for (final state in [
            PermissionState.denied,
            PermissionState.limited,
          ]) {
            plugin.permission = state;

            expect(
              await devicePhotos.requestAccess(),
              DevicePhotoAccessRequest.unavailable,
            );
          }
          expect(plugin.permissionRequests, 0);
        });
      });

      group('on Android 12 and earlier', () {
        setUp(() {
          sdk = 32;
          plugin.permission = PermissionState.denied;
        });

        test('reports an allowed request', () async {
          rationales = [false];
          plugin.answer = PermissionState.authorized;

          expect(
            await devicePhotos.requestAccess(),
            DevicePhotoAccessRequest.allowed,
          );
        });

        test('reports a declined request', () async {
          for (final shown in [
            [false, true],
            [true, false],
          ]) {
            rationales = shown;

            expect(
              await devicePhotos.requestAccess(),
              DevicePhotoAccessRequest.declined,
            );
          }
        });

        test('is unavailable when no dialog appears', () async {
          rationales = [false, false];

          expect(
            await devicePhotos.requestAccess(),
            DevicePhotoAccessRequest.unavailable,
          );
        });
      });
    });

    group('read', () {
      test('returns the original file', () async {
        plugin.file = File('original.jpg');

        expect((await devicePhotos.read('found'))?.path, 'original.jpg');
      });

      test('returns null when the photo is missing', () async {
        expect(await devicePhotos.read('missing'), isNull);
      });

      test('returns null when the photo cannot be read', () async {
        plugin.error = PlatformException(code: 'denied');

        expect(await devicePhotos.read('found'), isNull);
      });
    });

    test('openSettings opens the app settings', () async {
      await devicePhotos.openSettings();

      expect(plugin.settingsOpened, 1);
    });

    test('pickFolder returns the selected folder', () async {
      channelResult = 'content://folder';

      expect(await devicePhotos.pickFolder(), 'content://folder');
    });

    group('findInFolder', () {
      test('returns the matching documents', () async {
        channelResult = {'1': 'content://document'};

        final found = await devicePhotos.findInFolder(
          folder: 'content://folder',
          ids: ['1'],
        );

        expect(found, {'1': 'content://document'});
        expect(calls.single.arguments, {
          'folder': 'content://folder',
          'ids': ['1'],
        });
      });

      test('returns nothing when the platform returns null', () async {
        final found = await devicePhotos.findInFolder(
          folder: 'folder',
          ids: [],
        );

        expect(found, isEmpty);
      });
    });

    test('copyDocument returns the copy', () async {
      channelResult = '/tmp/copy';

      final file = await devicePhotos.copyDocument('content://document');

      expect(file.path, '/tmp/copy');
      expect(calls.single.arguments, {'document': 'content://document'});
    });
  });
}
