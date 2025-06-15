import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/src/diary_command.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../utils/mock.mocks.dart';

void main() {
  group('DiaryCommand', () {
    test('addDiary adds a new diary entry to the database', () async {
      final mockDbClient = MockDbClient();
      final diaryCommand = DiaryCommand(dbClient: mockDbClient);

      const content = 'New Diary Entry';
      final date = DateTime(2024, 1, 10);

      final diary = Diary(
        id: 1,
        content: content,
        date: date,
        createdAt: clock.now(),
        updatedAt: clock.now(),
      );

      when(
        mockDbClient.insertDiary(content: content, date: date),
      ).thenAnswer((_) async => diary);

      await diaryCommand.addDiary(content: content, date: date);

      verify(mockDbClient.insertDiary(content: content, date: date)).called(1);
    });

    test(
      'updateDiary updates an existing diary entry in the database',
      () async {
        final mockDbClient = MockDbClient();
        final diaryCommand = DiaryCommand(dbClient: mockDbClient);

        const id = 1;
        const content = 'Updated Diary Entry';

        when(
          mockDbClient.updateDiary(id: id, content: content),
        ).thenAnswer((_) async => 1);

        await diaryCommand.updateDiary(id: id, content: content);

        verify(mockDbClient.updateDiary(id: id, content: content)).called(1);
      },
    );
  });
}
