import 'dart:io';

import 'package:backup/backup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:provider_utils/provider_utils.dart';

import '../../golden/golden_test_helpers.mocks.dart';

void main() {
  group('backupControllerProvider', () {
    test('uses the photo storage from its provider', () {
      final photoStorage = PhotoStorage(directory: Directory.systemTemp);
      final container = ProviderContainer(
        overrides: [
          dbClientProvider.overrideWithValue(MockDbClient()),
          packageInfoProvider.overrideWithValue(
            PackageInfo(
              appName: 'OnePage',
              packageName: 'onepage',
              version: '1.0.0',
              buildNumber: '1',
            ),
          ),
          photoStorageProvider.overrideWithValue(photoStorage),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(backupControllerProvider);

      expect(controller, isA<BackupController>());
      expect(controller.photoStorage, photoStorage);
    });
  });
}
