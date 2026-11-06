import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:photo_storage/photo_storage.dart';

import '../../golden/golden_test_helpers.mocks.dart';

void main() {
  group('photoRecoveryCommandProvider', () {
    test('uses the photo storage and the photo library', () {
      final photoStorage = PhotoStorage(directory: Directory.systemTemp);
      final container = ProviderContainer(
        overrides: [
          dbClientProvider.overrideWithValue(MockDbClient()),
          photoStorageProvider.overrideWithValue(photoStorage),
        ],
      );
      addTearDown(container.dispose);

      final command = container.read(photoRecoveryCommandProvider);

      expect(command.photoStorage, photoStorage);
      expect(command.photoLibrary, container.read(photoLibraryProvider));
    });
  });
}
