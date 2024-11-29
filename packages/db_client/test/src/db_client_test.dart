import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
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

  group('insertDiary', () {
    test('should insert a diary entry and retrieve it correctly', () async {
      final diary = DiariesCompanion(
        content: const Value('Test diary content'),
        date: Value(clock.now()),
      );

      final id = await dbClient.insertDiary(diary);
      final retrievedDiaries = await dbClient.getDiaries(
        clock.now().subtract(const Duration(days: 1)),
        clock.now().add(const Duration(days: 1)),
      );

      expect(retrievedDiaries.length, 1);
      expect(retrievedDiaries.first.id, id);
      expect(retrievedDiaries.first.content, 'Test diary content');
    });
  });

  group('getDiaries', () {
    test('should retrieve diaries within the specified date range', () async {
      final now = clock.now();
      final diary1 = DiariesCompanion(
        content: const Value('Diary 1'),
        date: Value(now.subtract(const Duration(days: 2))),
      );
      final diary2 = DiariesCompanion(
        content: const Value('Diary 2'),
        date: Value(now.subtract(const Duration(days: 1))),
      );
      final diary3 = DiariesCompanion(
        content: const Value('Diary 3'),
        date: Value(now),
      );

      await dbClient.insertDiary(diary1);
      await dbClient.insertDiary(diary2);
      await dbClient.insertDiary(diary3);

      final retrievedDiaries = await dbClient.getDiaries(
        now.subtract(const Duration(days: 1)),
        now.add(const Duration(days: 1)),
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
      final diary1 = DiariesCompanion(
        content: const Value('Initial content 1'),
        date: Value(now.subtract(const Duration(days: 2))),
      );
      final diary2 = DiariesCompanion(
        content: const Value('Initial content 2'),
        date: Value(now.subtract(const Duration(days: 1))),
      );
      final diary3 = DiariesCompanion(
        content: const Value('Initial content 3'),
        date: Value(now),
      );

      await dbClient.insertDiary(diary1);
      final idToUpdate = await dbClient.insertDiary(diary2);
      await dbClient.insertDiary(diary3);

      const updatedDiary = DiariesCompanion(
        content: Value('Updated content 2'),
      );

      await dbClient.updateDiary(idToUpdate, updatedDiary);

      final retrievedDiaries = await dbClient.getDiaries(
        now.subtract(const Duration(days: 3)),
        now.add(const Duration(days: 1)),
      );

      expect(retrievedDiaries.length, 3);
      final updatedEntry =
          retrievedDiaries.firstWhere((d) => d.id == idToUpdate);
      expect(updatedEntry.content, 'Updated content 2');

      final otherEntries = retrievedDiaries.where((d) => d.id != idToUpdate);
      expect(
        otherEntries.map((d) => d.content),
        containsAll(['Initial content 1', 'Initial content 3']),
      );
    });
  });
}
