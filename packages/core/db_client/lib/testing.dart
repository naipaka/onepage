/// Helpers for tests of code that uses [DbClient].
library;

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'db_client.dart';

/// Creates a [DbClient] on a new in-memory database.
DbClient createInMemoryDbClient() {
  return DbClient(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}

/// Creates a [DbClient] on the database file at [file].
DbClient createFileDbClient(File file) => DbClient(NativeDatabase(file));

/// Adds a diary image that refers to [photoId] in the device's photo library.
///
/// The app no longer creates these images, but databases from older versions
/// still have them.
Future<DiaryImage> insertExternalDiaryImage(
  DbClient dbClient, {
  required int diaryId,
  required String photoId,
}) {
  return dbClient
      .into(dbClient.diaryImages)
      .insertReturning(
        DiaryImagesCompanion.insert(
          diaryId: diaryId,
          photoId: Value(photoId),
        ),
      );
}
