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
          retrievedDiaries.map((d) => d.entry.content),
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
          (d) => d.entry.id == updated.id,
        );
        expect(updatedEntry.entry.content, 'Updated content 2');

        final otherEntries = retrievedDiaries.where(
          (d) => d.entry.id != updated.id,
        );
        expect(
          otherEntries.map((d) => d.entry.content),
          containsAll(['Initial content 1', 'Initial content 3']),
        );
      });
    });

    group('searchDiaries', () {
      test('should search diaries by content case-insensitively', () async {
        final now = clock.now();

        await dbClient.insertDiary(
          content: 'Today I went to Tokyo',
          date: now.subtract(const Duration(days: 3)),
        );
        await dbClient.insertDiary(
          content: 'Yesterday I visited Osaka',
          date: now.subtract(const Duration(days: 2)),
        );
        await dbClient.insertDiary(
          content: 'I love TOKYO very much',
          date: now.subtract(const Duration(days: 1)),
        );
        await dbClient.insertDiary(
          content: 'Nothing special today',
          date: now,
        );

        final searchResults = await dbClient.searchDiaries(
          searchTerm: 'tokyo',
        );

        expect(searchResults.length, 2);
        expect(
          searchResults.map((d) => d.content),
          containsAll(['Today I went to Tokyo', 'I love TOKYO very much']),
        );
      });

      test('should return results ordered by date descending', () async {
        final now = clock.now();

        await dbClient.insertDiary(
          content: 'First diary with keyword',
          date: now.subtract(const Duration(days: 3)),
        );
        await dbClient.insertDiary(
          content: 'Second diary with keyword',
          date: now.subtract(const Duration(days: 1)),
        );
        await dbClient.insertDiary(
          content: 'Third diary with keyword',
          date: now,
        );

        final searchResults = await dbClient.searchDiaries(
          searchTerm: 'keyword',
        );

        expect(searchResults.length, 3);
        expect(searchResults[0].content, 'Third diary with keyword');
        expect(searchResults[1].content, 'Second diary with keyword');
        expect(searchResults[2].content, 'First diary with keyword');
      });

      test('should respect limit and offset parameters', () async {
        final now = clock.now();

        for (var i = 0; i < 5; i++) {
          await dbClient.insertDiary(
            content: 'Test diary $i',
            date: now.subtract(Duration(days: i)),
          );
        }

        final firstPage = await dbClient.searchDiaries(
          searchTerm: 'Test',
          limit: 2,
          offset: 0,
        );

        expect(firstPage.length, 2);
        expect(firstPage[0].content, 'Test diary 0');
        expect(firstPage[1].content, 'Test diary 1');

        final secondPage = await dbClient.searchDiaries(
          searchTerm: 'Test',
          limit: 2,
          offset: 2,
        );

        expect(secondPage.length, 2);
        expect(secondPage[0].content, 'Test diary 2');
        expect(secondPage[1].content, 'Test diary 3');
      });

      test('should return empty list when no matches found', () async {
        final now = clock.now();

        await dbClient.insertDiary(
          content: 'No matching content here',
          date: now,
        );

        final searchResults = await dbClient.searchDiaries(
          searchTerm: 'nonexistent',
        );

        expect(searchResults, isEmpty);
      });

      test('should handle empty search term', () async {
        final now = clock.now();

        await dbClient.insertDiary(
          content: 'Some content',
          date: now,
        );

        final searchResults = await dbClient.searchDiaries(
          searchTerm: '',
        );

        expect(searchResults.length, 1);
      });

      test('should search partial words', () async {
        final now = clock.now();

        await dbClient.insertDiary(
          content: 'Programming is fun',
          date: now,
        );

        final searchResults = await dbClient.searchDiaries(
          searchTerm: 'prog',
        );

        expect(searchResults.length, 1);
        expect(searchResults[0].content, 'Programming is fun');
      });
    });

    group('countUniqueDaysWithContentInRange', () {
      test('should count unique days with non-empty content', () async {
        final now = clock.now();
        final startDate = now.subtract(const Duration(days: 10));
        final endDate = now.add(const Duration(days: 1));

        // Insert entries with content
        await dbClient.insertDiary(
          content: 'Day 1 content',
          date: now.subtract(const Duration(days: 5)),
        );
        await dbClient.insertDiary(
          content: 'Day 2 content',
          date: now.subtract(const Duration(days: 3)),
        );
        await dbClient.insertDiary(
          content: 'Day 3 content',
          date: now.subtract(const Duration(days: 1)),
        );

        final count = await dbClient.countUniqueDaysWithContentInRange(
          from: startDate,
          to: endDate,
        );

        expect(count, 3);
      });

      test('should exclude empty content entries', () async {
        final now = clock.now();
        final startDate = now.subtract(const Duration(days: 10));
        final endDate = now.add(const Duration(days: 1));

        // Insert entries with content
        await dbClient.insertDiary(
          content: 'Valid content',
          date: now.subtract(const Duration(days: 5)),
        );
        // Insert empty content entry
        await dbClient.insertDiary(
          content: '',
          date: now.subtract(const Duration(days: 3)),
        );

        final count = await dbClient.countUniqueDaysWithContentInRange(
          from: startDate,
          to: endDate,
        );

        expect(count, 1);
      });

      test('should exclude whitespace-only content entries', () async {
        final now = clock.now();
        final startDate = now.subtract(const Duration(days: 10));
        final endDate = now.add(const Duration(days: 1));

        // Insert entries with content
        await dbClient.insertDiary(
          content: 'Valid content',
          date: now.subtract(const Duration(days: 5)),
        );
        // Insert whitespace-only content entry
        await dbClient.insertDiary(
          content: '   \n\t  ',
          date: now.subtract(const Duration(days: 3)),
        );

        final count = await dbClient.countUniqueDaysWithContentInRange(
          from: startDate,
          to: endDate,
        );

        expect(count, 1);
      });

      test('should respect date range boundaries', () async {
        final now = clock.now();
        final startDate = now.subtract(const Duration(days: 5));
        final endDate = now.subtract(const Duration(days: 1));

        // Insert entry before range
        await dbClient.insertDiary(
          content: 'Before range',
          date: now.subtract(const Duration(days: 10)),
        );
        // Insert entry in range
        await dbClient.insertDiary(
          content: 'In range',
          date: now.subtract(const Duration(days: 3)),
        );
        // Insert entry after range
        await dbClient.insertDiary(
          content: 'After range',
          date: now,
        );

        final count = await dbClient.countUniqueDaysWithContentInRange(
          from: startDate,
          to: endDate,
        );

        expect(count, 1);
      });

      test('should return 0 when no entries match criteria', () async {
        final now = clock.now();
        final startDate = now.subtract(const Duration(days: 10));
        final endDate = now.add(const Duration(days: 1));

        // Insert only empty content entry
        await dbClient.insertDiary(
          content: '',
          date: now.subtract(const Duration(days: 5)),
        );

        final count = await dbClient.countUniqueDaysWithContentInRange(
          from: startDate,
          to: endDate,
        );

        expect(count, 0);
      });
    });
  });
}
