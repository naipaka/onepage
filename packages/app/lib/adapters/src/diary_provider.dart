import 'package:clock/clock.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scroll_calendar/scroll_calendar.dart';

import 'db_client_provider.dart';

part 'diary_provider.g.dart';

/// A provider that creates a [DiaryCommand] instance.
///
/// {@macro diary.DiaryCommand}
@Riverpod(keepAlive: true)
DiaryCommand diaryCommand(Ref ref) {
  final dbClient = ref.watch(dbClientProvider);
  return DiaryCommand(dbClient: dbClient);
}

/// A provider that creates a [DiaryQuery] instance.
///
/// {@macro diary.DiaryQuery}
@Riverpod(keepAlive: true)
DiaryQuery diaryQuery(Ref ref) {
  final dbClient = ref.watch(dbClientProvider);
  return DiaryQuery(dbClient: dbClient);
}

/// Provides a list of diaries within the specified date range.
@riverpod
Future<List<Diary>> diaries(
  // Changed `from` to `fromDate`/`toDate` to avoid conflict with code generated by Riverpod Generator.
  Ref ref, {
  required DateTime fromDate,
  required DateTime toDate,
}) async {
  final query = ref.watch(diaryQueryProvider);
  return query.getDiaries(from: fromDate, to: toDate);
}

/// Type definition for a list of diaries with dates.
typedef DiariesWithDates = ({List<Diary> diaries, List<DateTime> dates});

/// Provides a list of diaries with dates within the specified date range.
@riverpod
class CachedDiaries extends _$CachedDiaries {
  final _now = clock.now();

  DiaryCommand get _diaryCommand => ref.read(diaryCommandProvider);

  @override
  Future<DiariesWithDates> build() async {
    final nextMonthDate = DateTime(_now.year, _now.month + 1);
    final dates = _now.datesInMonths(-1, 0)..add(nextMonthDate);
    final diaries = await ref.watch(
      diariesProvider(
        fromDate: dates.first,
        toDate: dates.last,
      ).future,
    );
    return (
      diaries: diaries,
      dates: dates,
    );
  }

  /// Load more older diaries.
  Future<void> loadMoreOlder() async {
    if (state.isLoading || !state.hasValue) {
      // Do nothing if the state is loading or has no value.
      return;
    }
    final current = state.requireValue;
    final previousMonthDates = current.dates.first.previousMonthDates;
    final diaries = await ref.watch(
      diariesProvider(
        fromDate: previousMonthDates.first,
        toDate: current.dates.last,
      ).future,
    );
    state = AsyncValue.data(
      (
        diaries: [...diaries, ...current.diaries],
        dates: [...previousMonthDates, ...current.dates],
      ),
    );
  }

  /// Add a new diary entry.
  Future<void> addDiary({
    required DateTime date,
    required String content,
  }) async {
    final diary = await _diaryCommand.addDiary(date: date, content: content);
    if (state.isLoading || !state.hasValue) {
      // Do nothing if the state is loading or has no value.
      return;
    }
    final current = state.requireValue;
    state = AsyncValue.data(
      (
        diaries: [...current.diaries, diary],
        dates: current.dates,
      ),
    );
  }

  /// Update an existing diary entry.
  Future<void> updateDiary({
    required int id,
    required String content,
  }) async {
    await _diaryCommand.updateDiary(id: id, content: content);
    if (state.isLoading || !state.hasValue) {
      // Do nothing if the state is loading or has no value.
      return;
    }
    final current = state.requireValue;
    final updatedDiaries = current.diaries.map((diary) {
      if (diary.id == id) {
        return diary.copyWith(content: content);
      }
      return diary;
    }).toList();
    state = AsyncValue.data(
      (
        diaries: updatedDiaries,
        dates: current.dates,
      ),
    );
  }
}
