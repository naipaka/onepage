import 'package:diary/src/diary_command.dart';
import 'package:test/test.dart';

import '../utils/db_client.dart';

void main() {
  group('DiaryCommand', () {
    final date = DateTime(2024, 1, 10);

    test('addDiary adds a new diary entry to the database', () async {
      final dbClient = createDbClient();
      final diaryCommand = DiaryCommand(dbClient: dbClient);

      final entry = await diaryCommand.addDiary(
        content: 'New Diary Entry',
        date: date,
      );

      expect(entry.content, 'New Diary Entry');
      expect(await dbClient.getDiaryByDate(date: date), entry);
    });

    test('updateDiary updates the content of a diary entry', () async {
      final dbClient = createDbClient();
      final diaryCommand = DiaryCommand(dbClient: dbClient);
      final entry = await dbClient.insertDiary(content: 'Before', date: date);

      await diaryCommand.updateDiary(id: entry.id, content: 'After');

      final updated = await dbClient.getDiaryByDate(date: date);
      expect(updated?.content, 'After');
    });
  });
}
