import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:photo_storage/photo_storage.dart';

void main() {
  group('photoStorageProvider', () {
    test('throws until it is overridden', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(photoStorageProvider),
        throwsA(
          isA<ProviderException>().having(
            (e) => e.exception,
            'exception',
            isA<UnimplementedError>(),
          ),
        ),
      );
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
