import 'dart:async';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:provider_utils/provider_utils.dart';

/// Returns a diary for every day of the range when [everyDay] is true.
class _FakeDiaryQuery implements DiaryQuery {
  bool everyDay = false;

  @override
  Future<List<Diary>> getDiaries({
    required DateTime from,
    required DateTime to,
  }) async {
    if (!everyDay) {
      return [];
    }
    return [
      for (
        var day = from;
        !day.isAfter(to);
        day = DateTime(day.year, day.month, day.day + 1)
      )
        Diary(
          entry: DiaryEntry(
            id: day.millisecondsSinceEpoch,
            content: '$day',
            date: day,
            createdAt: day,
            updatedAt: day,
          ),
          images: const [],
        ),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDiaryCommand implements DiaryCommand {
  @override
  Future<DiaryEntry> addDiary({
    required String content,
    required DateTime date,
  }) async {
    return DiaryEntry(
      id: 1,
      content: content,
      date: date,
      createdAt: date,
      updatedAt: date,
    );
  }

  @override
  Future<void> updateDiary({
    required int id,
    required String content,
  }) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDiaryImageCommand implements DiaryImageCommand {
  bool failsToStore = false;
  Completer<void>? storing;

  @override
  Future<String> storePhoto(String path) async {
    if (failsToStore) {
      throw Exception('store');
    }
    await storing?.future;
    return 'photo.jpg';
  }

  int addDiaryImageCalls = 0;

  @override
  Future<({DiaryEntry entry, DiaryImage image})> addDiaryImage({
    required DateTime date,
    required String fileName,
  }) async {
    addDiaryImageCalls++;
    final entry = DiaryEntry(
      id: 1,
      content: '',
      date: date,
      createdAt: clock.now(),
      updatedAt: clock.now(),
    );
    final image = DiaryImage(
      id: 1,
      diaryId: entry.id,
      fileName: fileName,
      createdAt: clock.now(),
      updatedAt: clock.now(),
    );
    return (entry: entry, image: image);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final date = DateTime(2026, 11, 5);
  late _FakeDiaryQuery diaryQuery;
  late _FakeDiaryCommand diaryCommand;
  late _FakeDiaryImageCommand imageCommand;
  late ProviderContainer container;

  setUp(() async {
    diaryQuery = _FakeDiaryQuery();
    diaryCommand = _FakeDiaryCommand();
    imageCommand = _FakeDiaryImageCommand();
    container = ProviderContainer(
      retry: noRetry,
      overrides: [
        diaryQueryProvider.overrideWithValue(diaryQuery),
        diaryCommandProvider.overrideWithValue(diaryCommand),
        diaryImageCommandProvider.overrideWithValue(imageCommand),
      ],
    );
    addTearDown(container.dispose);
    container.listen(cachedDiariesProvider, (_, _) {});
    await container.read(cachedDiariesProvider.future);
  });

  Future<void> addImage() {
    return container
        .read(cachedDiariesProvider.notifier)
        .addImage(date: date, path: 'picked.jpg');
  }

  group('loadMoreOlder', () {
    test('adds the diaries of the previous month once', () async {
      diaryQuery.everyDay = true;
      container
        ..invalidate(diariesProvider)
        ..invalidate(cachedDiariesProvider);
      await container.read(cachedDiariesProvider.future);
      final notifier = container.read(cachedDiariesProvider.notifier);

      await notifier.loadMoreOlder();
      await notifier.loadMoreOlder();

      final state = container.read(cachedDiariesProvider).requireValue;
      final diaryDates = state.diaries.map((d) => d.entry.date).toList();
      expect(diaryDates.toSet(), hasLength(diaryDates.length));
      expect(diaryDates.toSet(), state.dates.toSet());
    });
  });

  group('addImage', () {
    test('adds a diary with the stored photo to the state', () async {
      await addImage();

      final state = container.read(cachedDiariesProvider).requireValue;
      expect(state.diaries.single.images.single.fileName, 'photo.jpg');
    });

    test('keeps a diary edited while the photo is being stored', () async {
      final notifier = container.read(cachedDiariesProvider.notifier);
      await notifier.addDiary(date: date, content: 'old');
      imageCommand.storing = Completer<void>();

      final adding = addImage();
      await notifier.updateDiary(id: 1, content: 'new');
      imageCommand.storing!.complete();
      await adding;

      final state = container.read(cachedDiariesProvider).requireValue;
      expect(state.diaries.single.entry.content, 'new');
      expect(state.diaries.single.images, hasLength(1));
    });

    test('does not add the image when the photo cannot be stored', () async {
      imageCommand.failsToStore = true;

      await expectLater(addImage(), throwsException);

      expect(imageCommand.addDiaryImageCalls, 0);
    });
  });
}
