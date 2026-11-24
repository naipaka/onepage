import 'dart:async';

import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:provider_utils/provider_utils.dart';

import '../../utils/clients.dart';

/// Searches the database, and fails or waits at the offsets given.
class _ControlledDiaryQuery extends DiaryQuery {
  new({required super.dbClient});

  final failingOffsets = <int>{};
  Completer<void>? waiting;

  @override
  Future<List<DiaryEntry>> searchDiaries({
    required String searchTerm,
    int? limit,
    int? offset,
  }) async {
    await waiting?.future;
    if (failingOffsets.contains(offset)) {
      throw Exception('search');
    }
    return super.searchDiaries(
      searchTerm: searchTerm,
      limit: limit,
      offset: offset,
    );
  }
}

void main() {
  late DbClient dbClient;
  late _ControlledDiaryQuery diaryQuery;
  late ProviderContainer container;

  /// 45 diaries with the term, one a day from the first of October, and one
  /// diary without it.
  Future<void> insertDiaries() async {
    for (var i = 0; i < 45; i++) {
      await dbClient.insertDiary(
        content: 'cafe $i',
        date: DateTime(2026, 10, 1 + i),
      );
    }
    await dbClient.insertDiary(content: 'rain', date: DateTime(2026, 9, 30));
  }

  setUp(() async {
    dbClient = createDbClient();
    await insertDiaries();
    diaryQuery = _ControlledDiaryQuery(dbClient: dbClient);
    container = ProviderContainer(
      retry: noRetry,
      overrides: [diaryQueryProvider.overrideWithValue(diaryQuery)],
    );
    addTearDown(container.dispose);
  });

  group('DiarySearchSession', () {
    DiarySearchSession notifier() =>
        container.read(diarySearchSessionProvider.notifier);

    test('starts with no term at the top', () {
      expect(container.read(diarySearchSessionProvider), (
        term: '',
        scrollOffset: 0.0,
      ));
    });

    test('keeps the scroll offset while the term stays', () {
      notifier()
        ..search('cafe')
        ..saveScrollOffset(120)
        ..search('cafe');

      expect(container.read(diarySearchSessionProvider), (
        term: 'cafe',
        scrollOffset: 120.0,
      ));
    });

    test('goes back to the top for another term', () {
      notifier()
        ..search('cafe')
        ..saveScrollOffset(120)
        ..search('rain');

      expect(container.read(diarySearchSessionProvider), (
        term: 'rain',
        scrollOffset: 0.0,
      ));
    });
  });

  group('DiarySearchResults', () {
    final cafe = diarySearchResultsProvider('cafe');

    Future<LoadedDiaryEntries> load() {
      container.listen(cafe, (_, _) {});
      return container.read(cafe.future);
    }

    List<String> contents() => [
      for (final entry in container.read(cafe).requireValue.entries)
        entry.content,
    ];

    test('loads the first page, the newest first', () async {
      final loaded = await load();

      expect(loaded.entries, hasLength(20));
      expect(loaded.entries.first.content, 'cafe 44');
      expect(loaded.hasMore, isTrue);
    });

    test('loadMore adds the next pages until none are left', () async {
      await load();
      final notifier = container.read(cafe.notifier);

      await notifier.loadMore();
      await notifier.loadMore();
      await notifier.loadMore();

      expect(contents(), [for (var i = 44; i >= 0; i--) 'cafe $i']);
      expect(container.read(cafe).requireValue.hasMore, isFalse);
    });

    test('calls during a load wait for it instead of loading again', () async {
      await load();
      final notifier = container.read(cafe.notifier);

      await Future.wait([notifier.loadMore(), notifier.loadMore()]);

      expect(contents(), [for (var i = 44; i >= 5; i--) 'cafe $i']);
    });

    test('keeps the loaded entries when loading more fails', () async {
      await load();
      diaryQuery.failingOffsets.add(20);

      await container.read(cafe.notifier).loadMore();

      final state = container.read(cafe);
      expect(state.hasError, isTrue);
      expect(state.value?.entries, hasLength(20));
    });

    test('loads the next page again after a failure', () async {
      await load();
      diaryQuery.failingOffsets.add(20);
      final notifier = container.read(cafe.notifier);
      await notifier.loadMore();

      diaryQuery.failingOffsets.clear();
      await notifier.loadMore();

      expect(container.read(cafe).hasError, isFalse);
      expect(contents(), hasLength(40));
    });

    test('fails with no entries when the first page fails', () async {
      diaryQuery.failingOffsets.add(0);

      await expectLater(load(), throwsException);

      expect(container.read(cafe).value, isNull);
    });

    test('reload reads the loaded pages again from the database', () async {
      await load();
      final notifier = container.read(cafe.notifier);
      await notifier.loadMore();
      final changed = container.read(cafe).requireValue.entries.first;
      await dbClient.updateDiary(id: changed.id, content: 'tea');

      await notifier.reload();

      expect(contents(), hasLength(40));
      expect(contents(), isNot(contains(changed.content)));
      expect(contents().first, 'cafe 43');
    });

    test('reload keeps the entries on the screen while it loads', () async {
      await load();
      diaryQuery.waiting = Completer();

      final reloading = container.read(cafe.notifier).reload();

      expect(container.read(cafe).value?.entries, hasLength(20));
      diaryQuery.waiting!.complete();
      await reloading;
    });

    test('reload searches again after the first page failed', () async {
      diaryQuery.failingOffsets.add(0);
      await expectLater(load(), throwsException);

      diaryQuery.failingOffsets.clear();
      await container.read(cafe.notifier).reload();

      expect(await container.read(cafe.future), isA<LoadedDiaryEntries>());
      expect(contents(), hasLength(20));
    });

    test(
      'stays without listeners while it is the term of the session',
      () async {
        container.read(diarySearchSessionProvider.notifier).search('cafe');
        final subscription = container.listen(cafe, (_, _) {});
        await container.read(cafe.future);

        subscription.close();
        await container.pump();

        expect(container.read(cafe.exists), isTrue);
      },
    );

    test('is disposed without listeners for another term', () async {
      container.read(diarySearchSessionProvider.notifier).search('cafe');
      final subscription = container.listen(cafe, (_, _) {});
      await container.read(cafe.future);
      subscription.close();

      container.read(diarySearchSessionProvider.notifier).search('rain');
      await container.pump();

      expect(container.read(cafe.exists), isFalse);
    });
  });
}
