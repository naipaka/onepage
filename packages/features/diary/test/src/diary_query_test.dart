import 'package:db_client/db_client.dart';
import 'package:diary/src/diary_query.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../utils/mock.mocks.dart';

void main() {
  group('DiaryQuery', () {
    test('getDiaries returns list of diaries within date range', () async {
      final mockDbClient = MockDbClient();
      final diaryQuery = DiaryQuery(dbClient: mockDbClient);

      final from = DateTime(2024);
      final to = DateTime(2024, 1, 31);

      final expectedDiaries = [
        Diary(
          id: 1,
          content: 'Diary 1',
          date: DateTime(2024, 1, 10),
          createdAt: DateTime(2024, 1, 10),
          updatedAt: DateTime(2024, 1, 10),
        ),
        Diary(
          id: 2,
          content: 'Diary 2',
          date: DateTime(2024, 1, 20),
          createdAt: DateTime(2024, 1, 20),
          updatedAt: DateTime(2024, 1, 20),
        ),
      ];

      when(
        mockDbClient.getDiaries(from: from, to: to),
      ).thenAnswer((_) async => expectedDiaries);

      final diaries = await diaryQuery.getDiaries(from: from, to: to);

      expect(diaries, equals(expectedDiaries));
      verify(mockDbClient.getDiaries(from: from, to: to)).called(1);
    });

    test('getDiaries returns empty list when no diaries found', () async {
      final mockDbClient = MockDbClient();
      final diaryQuery = DiaryQuery(dbClient: mockDbClient);

      final from = DateTime(2024);
      final to = DateTime(2024, 1, 31);

      when(
        mockDbClient.getDiaries(from: from, to: to),
      ).thenAnswer((_) async => []);

      final diaries = await diaryQuery.getDiaries(from: from, to: to);

      expect(diaries, isEmpty);
      verify(mockDbClient.getDiaries(from: from, to: to)).called(1);
    });

    test(
      'searchDiaries returns list of diaries matching search term',
      () async {
        final mockDbClient = MockDbClient();
        final diaryQuery = DiaryQuery(dbClient: mockDbClient);

        const searchTerm = 'tokyo';
        const limit = 10;
        const offset = 0;

        final expectedDiaries = [
          Diary(
            id: 1,
            content: 'I went to Tokyo',
            date: DateTime(2024, 1, 10),
            createdAt: DateTime(2024, 1, 10),
            updatedAt: DateTime(2024, 1, 10),
          ),
          Diary(
            id: 2,
            content: 'Tokyo is beautiful',
            date: DateTime(2024, 1, 20),
            createdAt: DateTime(2024, 1, 20),
            updatedAt: DateTime(2024, 1, 20),
          ),
        ];

        when(
          mockDbClient.searchDiaries(
            searchTerm: searchTerm,
            limit: limit,
            offset: offset,
          ),
        ).thenAnswer((_) async => expectedDiaries);

        final diaries = await diaryQuery.searchDiaries(
          searchTerm: searchTerm,
          limit: limit,
          offset: offset,
        );

        expect(diaries, equals(expectedDiaries));
        verify(
          mockDbClient.searchDiaries(
            searchTerm: searchTerm,
            limit: limit,
            offset: offset,
          ),
        ).called(1);
      },
    );

    test('searchDiaries returns empty list when no matches found', () async {
      final mockDbClient = MockDbClient();
      final diaryQuery = DiaryQuery(dbClient: mockDbClient);

      const searchTerm = 'nonexistent';

      when(
        mockDbClient.searchDiaries(searchTerm: searchTerm),
      ).thenAnswer((_) async => []);

      final diaries = await diaryQuery.searchDiaries(searchTerm: searchTerm);

      expect(diaries, isEmpty);
      verify(mockDbClient.searchDiaries(searchTerm: searchTerm)).called(1);
    });

    test('searchDiaries handles null limit and offset', () async {
      final mockDbClient = MockDbClient();
      final diaryQuery = DiaryQuery(dbClient: mockDbClient);

      const searchTerm = 'test';
      final expectedDiaries = [
        Diary(
          id: 1,
          content: 'Test diary',
          date: DateTime(2024, 1, 10),
          createdAt: DateTime(2024, 1, 10),
          updatedAt: DateTime(2024, 1, 10),
        ),
      ];

      when(
        mockDbClient.searchDiaries(searchTerm: searchTerm),
      ).thenAnswer((_) async => expectedDiaries);

      final diaries = await diaryQuery.searchDiaries(searchTerm: searchTerm);

      expect(diaries, equals(expectedDiaries));
      verify(mockDbClient.searchDiaries(searchTerm: searchTerm)).called(1);
    });
  });
}
