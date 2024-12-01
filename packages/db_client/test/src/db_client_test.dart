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
      final id = await dbClient.insertDiary(
        content: 'Test diary content',
        date: clock.now(),
      );
      final retrievedDiaries = await dbClient.getDiaries(
        from: clock.now().subtract(const Duration(days: 1)),
        to: clock.now().add(const Duration(days: 1)),
      );

      expect(retrievedDiaries.length, 1);
      expect(retrievedDiaries.first.id, id);
      expect(retrievedDiaries.first.content, 'Test diary content');
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
      await dbClient.insertDiary(
        content: 'Diary 3',
        date: now,
      );

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
      final idToUpdate = await dbClient.insertDiary(
        content: 'Initial content 2',
        date: now.subtract(const Duration(days: 1)),
      );
      await dbClient.insertDiary(
        content: 'Initial content 3',
        date: now,
      );

      await dbClient.updateDiary(
        id: idToUpdate,
        content: 'Updated content 2',
      );

      final retrievedDiaries = await dbClient.getDiaries(
        from: now.subtract(const Duration(days: 3)),
        to: now.add(const Duration(days: 1)),
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
