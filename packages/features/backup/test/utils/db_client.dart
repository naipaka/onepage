import 'dart:io';

import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a [DbClient] on an in-memory database and opens it.
Future<DbClient> openDbClient() async {
  final dbClient = createInMemoryDbClient();
  await dbClient.getDiaryImageFileNames();
  return dbClient;
}

/// Writes a database file at [path] with a diary of [content].
Future<File> writeDatabaseFile(String path, {required String content}) async {
  final dbClient = createFileDbClient(File(path));
  await dbClient.insertDiary(content: content, date: DateTime(2024));
  await dbClient.close();
  return File(path);
}

/// Returns the contents of the diaries in the database file at [path].
Future<List<String>> readDiaryContents(String path) async {
  final dbClient = createFileDbClient(File(path));
  addTearDown(dbClient.close);
  final diaries = await dbClient.getDiaries(
    from: DateTime(2000),
    to: DateTime(2100),
  );
  return [for (final diary in diaries) diary.entry.content];
}
