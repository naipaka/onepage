import 'dart:async';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:provider_utils/provider_utils.dart';

import '../../utils/clients.dart';

/// Searches the database, and fails at the offsets given.
class _ControlledDiaryQuery extends DiaryQuery {
  new({required super.dbClient});

  final failingOffsets = <int>{};

  @override
  int minSearchTermLength = 2;

  @override
  Future<List<DiaryEntry>> searchDiaries({
    required String searchTerm,
    int? limit,
    int? offset,
  }) async {
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
      overrides: [
        dbClientProvider.overrideWithValue(dbClient),
        diaryQueryProvider.overrideWithValue(diaryQuery),
        prefsClientProvider.overrideWithValue(createPrefsClient()),
      ],
    );
    addTearDown(container.dispose);
  });

  group('DiarySearchSession', () {
    DiarySearchSession notifier() =>
        container.read(diarySearchSessionProvider.notifier);

    test('starts with no term at the top', () {
      expect(container.read(diarySearchSessionProvider), (
        input: '',
        term: '',
        scrollOffset: 0.0,
      ));
    });

    test('searches the input without the spaces around it', () {
      notifier().search(' cafe ', incremental: true);

      expect(container.read(diarySearchSessionProvider), (
        input: ' cafe ',
        term: 'cafe',
        scrollOffset: 0.0,
      ));
    });

    test('searches nothing for a term shorter than the minimum', () {
      diaryQuery.minSearchTermLength = 5;

      notifier().search('cafe', incremental: true);

      expect(container.read(diarySearchSessionProvider), (
        input: 'cafe',
        term: '',
        scrollOffset: 0.0,
      ));
    });

    test('keeps the scroll offset while the term stays', () {
      notifier()
        ..search('cafe', incremental: true)
        ..saveScrollOffset(120)
        ..search('cafe ', incremental: true);

      expect(container.read(diarySearchSessionProvider), (
        input: 'cafe ',
        term: 'cafe',
        scrollOffset: 120.0,
      ));
    });

    test('goes back to the top for another term', () {
      notifier()
        ..search('cafe', incremental: true)
        ..saveScrollOffset(120)
        ..search('rain', incremental: true);

      expect(container.read(diarySearchSessionProvider), (
        input: 'rain',
        term: 'rain',
        scrollOffset: 0.0,
      ));
    });

    test('adds the term to the recent terms when not incremental', () async {
      await notifier().search(' cafe ', incremental: false);

      expect(container.read(recentDiarySearchTermsProvider), ['cafe']);
    });

    test('adds no term to the recent terms when incremental', () async {
      await notifier().search('cafe', incremental: true);

      expect(container.read(recentDiarySearchTermsProvider), isEmpty);
    });

    test('adds nothing to the recent terms when nothing is searched', () async {
      await notifier().search('c', incremental: false);

      expect(container.read(recentDiarySearchTermsProvider), isEmpty);
    });
  });

  group('DiarySearchResults', () {
    final cafe = diarySearchResultsProvider;

    setUp(() {
      container
          .read(diarySearchSessionProvider.notifier)
          .search('cafe', incremental: true);
    });

    Future<LoadedDiaryEntries> load() {
      container.listen(cafe, (_, _) {});
      return container.read(cafe.future);
    }

    List<String> contents() => [
      for (final entry in container.read(cafe).requireValue.entries)
        entry.content,
    ];

    /// Waits for the next entries of the results.
    Future<List<String>> nextContents() {
      final next = Completer<List<String>>();
      final subscription = container.listen(cafe, (_, results) {
        if (!next.isCompleted && results.hasValue) {
          next.complete([
            for (final entry in results.requireValue.entries) entry.content,
          ]);
        }
      });
      return next.future.whenComplete(subscription.close);
    }

    /// Loads [CachedDiaries] around the diaries of November 2026, and
    /// returns its notifier.
    Future<CachedDiaries> loadCachedDiaries() async {
      final notifier = withClock(
        Clock.fixed(DateTime(2026, 11, 10)),
        () {
          container.listen(cachedDiariesProvider, (_, _) {});
          return container.read(cachedDiariesProvider.notifier);
        },
      );
      await container.read(cachedDiariesProvider.future);
      return notifier;
    }

    Future<DiaryEntry> entryOf(String content) async =>
        (await dbClient.searchDiaries(searchTerm: content)).single;

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

    test('has no entries for an empty term, searching nothing', () {
      diaryQuery.failingOffsets.add(0);
      container
          .read(diarySearchSessionProvider.notifier)
          .search('', incremental: true);

      final results = container.read(cafe);

      expect(
        results,
        const AsyncData<LoadedDiaryEntries>(
          (entries: [], hasMore: false),
        ),
      );
    });

    test('searches again when the term changes', () async {
      await load();

      await container
          .read(diarySearchSessionProvider.notifier)
          .search('rain', incremental: true);

      expect(
        (await container.read(cafe.future)).entries.map((e) => e.content),
        ['rain'],
      );
    });

    test('stays without listeners', () async {
      final subscription = container.listen(cafe, (_, _) {});
      await container.read(cafe.future);

      subscription.close();
      await container.pump();

      expect(container.read(cafe.exists), isTrue);
    });

    group('when a diary of CachedDiaries changes', () {
      test('updates a loaded entry that still contains the term', () async {
        await load();
        final diaries = await loadCachedDiaries();
        final entry = await entryOf('cafe 44');

        final next = nextContents();
        await diaries.updateDiary(id: entry.id, content: 'cafe tea');

        expect((await next).first, 'cafe tea');
      });

      test('removes a loaded entry that no longer contains the term', () async {
        await load();
        final diaries = await loadCachedDiaries();
        final entry = await entryOf('cafe 44');

        final next = nextContents();
        await diaries.updateDiary(id: entry.id, content: 'tea');

        final contents = await next;
        expect(contents, hasLength(19));
        expect(contents.first, 'cafe 43');
      });

      test('adds a diary with the term among the loaded dates', () async {
        await load();
        final diaries = await loadCachedDiaries();

        final next = nextContents();
        await diaries.addDiary(date: DateTime(2026, 11, 20), content: 'cafe');

        final contents = await next;
        expect(contents, hasLength(21));
        expect(contents.first, 'cafe');
      });

      test('leaves out a diary older than the loaded dates', () async {
        await load();
        final diaries = await loadCachedDiaries();
        final entry = await entryOf('cafe 0');

        final next = nextContents();
        await diaries.updateDiary(id: entry.id, content: 'cafe zero');

        final contents = await next;
        expect(contents, hasLength(20));
        expect(contents, isNot(contains('cafe zero')));
      });

      test('follows the change without listeners', () async {
        final subscription = container.listen(cafe, (_, _) {});
        await container.read(cafe.future);
        final diaries = await loadCachedDiaries();
        final entry = await entryOf('cafe 44');
        subscription.close();
        await container.pump();

        final next = nextContents();
        await diaries.updateDiary(id: entry.id, content: 'tea');

        expect((await next).first, 'cafe 43');
      });
    });
  });
}
