import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const _libraryChannel = MethodChannel('com.naipaka.onepage/photo_library');

class _FakePlugin extends Fake
    with MockPlatformInterfaceMixin
    implements PhotoManagerPlugin {
  PermissionState permission = PermissionState.authorized;
  int permissionRequests = 0;
  int settingsOpened = 0;
  File? file;
  Exception? error;

  @override
  Future<PermissionState> requestPermissionExtend(
    PermissionRequestOption requestOption,
  ) async {
    permissionRequests++;
    return permission;
  }

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

  group('PhotoLibrary', () {
    const library = PhotoLibrary();
    late _FakePlugin plugin;
    late List<MethodCall> calls;
    var sdk = 34;
    Object? channelResult;

    setUp(() {
      plugin = _FakePlugin();
      PhotoManager.withPlugin(plugin);
      calls = [];
      sdk = 34;
      channelResult = null;
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_libraryChannel, (call) async {
            calls.add(call);
            return call.method == 'sdkInt' ? sdk : channelResult;
          });
    });

    tearDown(() {
      debugDefaultTargetPlatformOverride = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_libraryChannel, null);
    });

    group('supportsFolder', () {
      test('is true on Android 10 and later', () async {
        sdk = 29;

        expect(await library.supportsFolder, isTrue);
      });

      test('is false before Android 10', () async {
        sdk = 28;

        expect(await library.supportsFolder, isFalse);
      });

      test('is false on iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        expect(await library.supportsFolder, isFalse);
        expect(calls, isEmpty);
      });
    });

    group('requestAccess', () {
      test('is denied without asking on Android 13 and later', () async {
        sdk = 33;

        expect(await library.requestAccess(), PhotoLibraryAccess.denied);
        expect(plugin.permissionRequests, 0);
      });

      test('maps the permission state', () async {
        sdk = 32;
        final expected = {
          PermissionState.authorized: PhotoLibraryAccess.full,
          PermissionState.limited: PhotoLibraryAccess.limited,
          PermissionState.denied: PhotoLibraryAccess.denied,
          PermissionState.restricted: PhotoLibraryAccess.denied,
        };

        for (final MapEntry(:key, :value) in expected.entries) {
          plugin.permission = key;

          expect(await library.requestAccess(), value);
        }
      });
    });

    group('read', () {
      test('returns the original file', () async {
        plugin.file = File('original.jpg');

        expect((await library.read('found'))?.path, 'original.jpg');
      });

      test('returns null when the photo is missing', () async {
        expect(await library.read('missing'), isNull);
      });

      test('returns null when the photo cannot be read', () async {
        plugin.error = PlatformException(code: 'denied');

        expect(await library.read('found'), isNull);
      });
    });

    test('openSettings opens the app settings', () async {
      await library.openSettings();

      expect(plugin.settingsOpened, 1);
    });

    test('pickFolder returns the selected folder', () async {
      channelResult = 'content://folder';

      expect(await library.pickFolder(), 'content://folder');
    });

    group('findInFolder', () {
      test('returns the matching documents', () async {
        channelResult = {'1': 'content://document'};

        final found = await library.findInFolder(
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
        final found = await library.findInFolder(folder: 'folder', ids: []);

        expect(found, isEmpty);
      });
    });

    test('copyDocument returns the copy', () async {
      channelResult = '/tmp/copy';

      final file = await library.copyDocument('content://document');

      expect(file.path, '/tmp/copy');
      expect(calls.single.arguments, {'document': 'content://document'});
    });
  });
}
