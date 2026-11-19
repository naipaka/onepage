import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:provider_utils/provider_utils.dart';

import '../../utils/clients.dart';

void main() {
  group('photoRecoveryCommandProvider', () {
    test('uses the photo storage and the device photos', () {
      final photoStorage = PhotoStorage(directory: Directory.systemTemp);
      final container = ProviderContainer(
        retry: noRetry,
        overrides: [
          dbClientProvider.overrideWithValue(createDbClient()),
          photoStorageProvider.overrideWithValue(photoStorage),
        ],
      );
      addTearDown(container.dispose);

      final command = container.read(photoRecoveryCommandProvider);

      expect(command.photoStorage, photoStorage);
      expect(command.devicePhotos, container.read(devicePhotosProvider));
    });
  });
}
