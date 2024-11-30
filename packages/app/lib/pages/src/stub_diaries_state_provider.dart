// For mocking diaries state.
// ignore_for_file: avoid_hardcoded_japanese
import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stub_diaries_state_provider.g.dart';

typedef _Diary = ({DateTime date, String content});

/// For mocking diaries state.
@riverpod
class StubDiariesState extends _$StubDiariesState {
  @override
  Future<List<_Diary>> build() async {
    final now = clock.now();
    return [
      (
        date: now.subtract(const Duration(days: 6)),
        content: '春はあけぼの。やうやう白くなりゆく山ぎは、すこしあかりて、紫だちたる 雲のほそくたなびきたる。',
      ),
      (
        date: now.subtract(const Duration(days: 4)),
        content:
            '''夏は夜。月のころはさらなり。やみもなほ、蛍の多く飛びちがひたる。また、 ただ一つ二つなど、ほのかにうち光りて行くもをかし。雨など降るもをかし。''',
      ),
      (
        date: now.subtract(const Duration(days: 2)),
        content:
            '''秋は夕暮れ。夕日のさして山の端いと近うなりたるに、烏の寝どころへ行く とて、三つ四つ、二つ三つなど、飛びいそぐさへあはれなり。まいて雁などの つらねたるが、いと小さく見ゆるはいとをかし。日入りはてて、風の音、虫の 音など、はたいふべきにあらず。''',
      ),
      (
        date: now,
        content:
            '''冬はつとめて。雪の降りたるはいふべきにもあらず、霜のいと白きも、また さらでもいと寒きに、火など急ぎおこして、炭もて渡るもいとつきづきし。 昼になりて、ぬるくゆるびもていけば、火桶の火も白き灰がちになりてわろし。''',
      ),
    ];
  }

  /// Update the diary.
  Future<void> save({
    required DateTime date,
    required String content,
  }) async {
    if (state.isLoading || !state.hasValue) {
      return;
    }

    final previous = state.requireValue;

    final diary = previous.firstWhereOrNull(
      (e) => DateUtils.isSameDay(e.date, date),
    );

    if (diary == null) {
      state = AsyncData([
        ...state.requireValue,
        (date: date, content: content),
      ]);
      return;
    }

    state = AsyncData([
      for (final e in previous)
        if (DateUtils.isSameDay(e.date, date))
          (date: date, content: content)
        else
          e,
    ]);
  }
}
