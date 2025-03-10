import 'dart:io';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/mock_path_provider.dart';

void main() {
  group('constructor', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    setUp(setUpMockPathProvider);

    tearDown(tearDownMockPathProvider);

    test('should be created successfully with default constructor', () {
      final dbClient = DbClient();
      addTearDown(() async {
        await dbClient.close();
      });
      expect(dbClient, isA<DbClient>());
    });
  });

  group('DbClient', () {
    late DbClient dbClient;

    setUp(() {
      final connection = DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      );
      dbClient = DbClient.forTesting(connection);
    });

    tearDown(() async {
      await dbClient.close();
    });

    group('writeBackupToFile', () {
      test('should write the database to a file', () async {
        const filePath = 'test_backup.db';
        await dbClient.writeBackupToFile(filePath: filePath);

        final file = File(filePath);
        expect(file.existsSync(), isTrue);

        await file.delete();
      });
    });

    group('insertDiary', () {
      test('should insert a diary entry and retrieve it correctly', () async {
        final now = clock.now();
        final diary = await dbClient.insertDiary(
          content: 'Test diary content',
          date: now,
        );

        expect(diary.id, 1);
        expect(diary.content, 'Test diary content');
        expect(diary.date.year, now.year);
        expect(diary.date.month, now.month);
        expect(diary.date.day, now.day);
      });
    });

    group('getDiaries', () {
      test('should retrieve diaries within the specified date range', () async {
        final now = clock.now();

        await dbClient.insertDiary(
          content: 'Diary 1',
          date: now.subtract(const Duration(days: 3)),
        );
        await dbClient.insertDiary(
          content: 'Diary 2',
          date: now.subtract(const Duration(days: 1)),
        );
        await dbClient.insertDiary(content: 'Diary 3', date: now);

        final retrievedDiaries = await dbClient.getDiaries(
          from: now.subtract(const Duration(days: 1)),
          to: now.add(const Duration(days: 1)),
        );

        expect(retrievedDiaries.length, 2);
        expect(
          retrievedDiaries.map((d) => d.content),
          containsAll(['Diary 2', 'Diary 3']),
        );
      });
    });

    group('updateDiary', () {
      test('should update a diary entry correctly', () async {
        final now = clock.now();

        await dbClient.insertDiary(
          content: 'Initial content 1',
          date: now.subtract(const Duration(days: 2)),
        );
        final updated = await dbClient.insertDiary(
          content: 'Initial content 2',
          date: now.subtract(const Duration(days: 1)),
        );
        await dbClient.insertDiary(content: 'Initial content 3', date: now);

        await dbClient.updateDiary(
          id: updated.id,
          content: 'Updated content 2',
        );

        final retrievedDiaries = await dbClient.getDiaries(
          from: now.subtract(const Duration(days: 3)),
          to: now.add(const Duration(days: 1)),
        );

        expect(retrievedDiaries.length, 3);
        final updatedEntry = retrievedDiaries.firstWhere(
          (d) => d.id == updated.id,
        );
        expect(updatedEntry.content, 'Updated content 2');

        final otherEntries = retrievedDiaries.where((d) => d.id != updated.id);
        expect(
          otherEntries.map((d) => d.content),
          containsAll(['Initial content 1', 'Initial content 3']),
        );
      });
    });
  });
}
