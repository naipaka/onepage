import 'dart:async';

import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';

class _FakeDiaryQuery implements DiaryQuery {
  @override
  Future<List<Diary>> getDiaries({
    required DateTime from,
    required DateTime to,
  }) async => [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDiaryCommand implements DiaryCommand {
  int addDiaryCalls = 0;

  @override
  Future<DiaryEntry> addDiary({
    required String content,
    required DateTime date,
  }) async {
    addDiaryCalls++;
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

  @override
  Future<DiaryImage> addDiaryImage({
    required int diaryId,
    required String fileName,
  }) async {
    return DiaryImage(
      id: 1,
      diaryId: diaryId,
      fileName: fileName,
      createdAt: clock.now(),
      updatedAt: clock.now(),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  final date = DateTime(2026, 11, 5);
  late _FakeDiaryCommand diaryCommand;
  late _FakeDiaryImageCommand imageCommand;
  late ProviderContainer container;

  setUp(() async {
    diaryCommand = _FakeDiaryCommand();
    imageCommand = _FakeDiaryImageCommand();
    container = ProviderContainer(
      overrides: [
        diaryQueryProvider.overrideWithValue(_FakeDiaryQuery()),
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

    test('does not create a diary when the photo cannot be stored', () async {
      imageCommand.failsToStore = true;

      await expectLater(addImage(), throwsException);

      expect(diaryCommand.addDiaryCalls, 0);
    });
  });
}
