import 'dart:io';

import 'package:diary/diary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:photo_storage/photo_storage.dart';

import '../../golden/golden_test_helpers.mocks.dart';

void main() {
  group('diaryImageCommandProvider', () {
    test('creates a command with the database and photo storage', () {
      final dbClient = MockDbClient();
      final photoStorage = PhotoStorage(directory: Directory.systemTemp);
      final container = ProviderContainer(
        overrides: [
          dbClientProvider.overrideWithValue(dbClient),
          photoStorageProvider.overrideWithValue(photoStorage),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(diaryImageCommandProvider),
        isA<DiaryImageCommand>()
            .having((c) => c.dbClient, 'dbClient', dbClient)
            .having((c) => c.photoStorage, 'photoStorage', photoStorage),
      );
    });
  });
}
