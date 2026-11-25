import 'package:db_client/db_client.dart';
import 'package:db_client/testing.dart';
import 'package:diary/src/diary_query.dart';
import 'package:test/test.dart';

void main() {
  group('DiaryQuery', () {
    late DbClient dbClient;
    late DiaryQuery diaryQuery;

    setUp(() {
      dbClient = createInMemoryDbClient();
      addTearDown(dbClient.close);
      diaryQuery = DiaryQuery(dbClient: dbClient);
    });

    group('getDiaries', () {
      test('returns the diaries within the date range', () async {
        final first = await dbClient.insertDiary(
          content: 'Diary 1',
          date: DateTime(2024, 1, 10),
        );
        final second = await dbClient.insertDiary(
          content: 'Diary 2',
          date: DateTime(2024, 1, 20),
        );
        await dbClient.insertDiary(
          content: 'Diary 3',
          date: DateTime(2024, 2),
        );

        final diaries = await diaryQuery.getDiaries(
          from: DateTime(2024),
          to: DateTime(2024, 1, 31),
        );

        expect(diaries, [
          Diary(entry: first, images: const []),
          Diary(entry: second, images: const []),
        ]);
      });

      test('returns an empty list when no diaries are found', () async {
        final diaries = await diaryQuery.getDiaries(
          from: DateTime(2024),
          to: DateTime(2024, 1, 31),
        );

        expect(diaries, isEmpty);
      });
    });

    test('minSearchTermLength is two characters', () {
      expect(diaryQuery.minSearchTermLength, 2);
    });

    group('searchDiaries', () {
      late DiaryEntry older;
      late DiaryEntry newer;

      setUp(() async {
        older = await dbClient.insertDiary(
          content: 'I went to Tokyo',
          date: DateTime(2024, 1, 10),
        );
        newer = await dbClient.insertDiary(
          content: 'Tokyo is beautiful',
          date: DateTime(2024, 1, 20),
        );
        await dbClient.insertDiary(
          content: 'Osaka',
          date: DateTime(2024, 1, 30),
        );
      });

      test('returns the diaries that contain the search term', () async {
        final diaries = await diaryQuery.searchDiaries(searchTerm: 'tokyo');

        expect(diaries, [newer, older]);
      });

      test('returns a page of the matches', () async {
        final diaries = await diaryQuery.searchDiaries(
          searchTerm: 'tokyo',
          limit: 1,
          offset: 1,
        );

        expect(diaries, [older]);
      });

      test('returns an empty list when no diaries match', () async {
        final diaries = await diaryQuery.searchDiaries(
          searchTerm: 'nonexistent',
        );

        expect(diaries, isEmpty);
      });
    });

    test('countUniqueDaysWithContentInRange counts the written days', () async {
      await dbClient.insertDiary(content: 'Diary', date: DateTime(2024, 1, 10));
      await dbClient.insertDiary(content: ' ', date: DateTime(2024, 1, 11));
      await dbClient.insertDiary(content: 'Diary', date: DateTime(2024, 2));

      final count = await diaryQuery.countUniqueDaysWithContentInRange(
        from: DateTime(2024),
        to: DateTime(2024, 1, 31),
      );

      expect(count, 1);
    });

    test('getExternalDiaryImages returns the images outside the app', () async {
      final entry = await dbClient.insertDiary(
        content: 'Diary',
        date: DateTime(2024),
      );
      await dbClient.insertDiaryImage(diaryId: entry.id, fileName: 'a.jpg');
      final external = await insertExternalDiaryImage(
        dbClient,
        diaryId: entry.id,
        photoId: 'photo',
      );

      expect(await diaryQuery.getExternalDiaryImages(), [external]);
    });
  });
}
