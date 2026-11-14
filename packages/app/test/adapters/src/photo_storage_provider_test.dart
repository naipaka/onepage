import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:photo_storage/photo_storage.dart';

void main() {
  group('photoStorageProvider', () {
    test('is not available before initialization', () {
      final container = ProviderContainer(
        overrides: [
          photoStorageInitializingProvider.overrideWith(
            (ref) => Completer<PhotoStorage>().future,
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(() => container.read(photoStorageProvider), throwsA(anything));
    });

    test('provides the initialized storage', () async {
      final storage = PhotoStorage(directory: Directory.systemTemp);
      final container = ProviderContainer(
        overrides: [
          photoStorageInitializingProvider.overrideWith(
            (ref) async => storage,
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(photoStorageInitializingProvider.future);

      expect(container.read(photoStorageProvider), storage);
    });
  });

  group('photoFileProvider', () {
    test('returns the file in photo storage', () {
      final directory = Directory.systemTemp;
      final container = ProviderContainer(
        overrides: [
          photoStorageProvider.overrideWithValue(
            PhotoStorage(directory: directory),
          ),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(photoFileProvider('photo.jpg')).path,
        '${directory.path}/photo.jpg',
      );
    });
  });
}
