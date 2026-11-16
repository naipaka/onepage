import 'package:db_client/db_client.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a [DbClient] on an in-memory database that closes after the test.
DbClient createDbClient() {
  final dbClient = DbClient.forTesting(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
  addTearDown(dbClient.close);
  return dbClient;
}

/// Adds a diary image that refers to [photoId] in the device's photo library.
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
