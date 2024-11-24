import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:widgets/widgets.dart';

import '../../extension/extension.dart';

/// 今日の日付にスクロールする関数の型定義。
///
/// [duration] スクロールアニメーションの持続時間。
/// [curve] スクロールアニメーションのイージング曲線。
typedef ScrollToTodayCallback = Future<void> Function({
  Duration duration,
  Curve curve,
});

/// 指定された日付にスクロールする関数の型定義。
///
/// [date] スクロール先の目標日付。
/// [duration] スクロールアニメーションの持続時間。
/// [curve] スクロールアニメーションのイージング曲線。
typedef ScrollToDateCallback = Future<void> Function(
  DateTime date, {
  Duration duration,
  Curve curve,
});

/// スクロール可能なカレンダーを制御するコントローラー。
///
/// ### 対応する ScrollCalendar
/// - [VerticalScrollCalendar]
class ScrollCalendarController {
  /// [ScrollCalendarController] constructor.
  ScrollCalendarController();

  ScrollToTodayCallback? _scrollToToday;
  ScrollToDateCallback? _scrollToDate;

  /// 今日の日付までスクロールする。
  Future<void> scrollToToday({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) async {
    assert(
      _scrollToToday != null,
      'The controller is not attached to any ScrollCalendar.',
    );
    await _scrollToToday?.call(duration: duration, curve: curve);
  }

  /// 指定した日付までスクロールする。
  Future<void> scrollToDate(
    DateTime date, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) async {
    assert(
      _scrollToDate != null,
      'The controller is not attached to any ScrollCalendar.',
    );
    await _scrollToDate?.call(date, duration: duration, curve: curve);
  }

  void _attach({
    required ScrollToTodayCallback scrollToToday,
    required ScrollToDateCallback scrollToDate,
  }) {
    assert(_scrollToToday == null && _scrollToDate == null);
    _scrollToToday = scrollToToday;
    _scrollToDate = scrollToDate;
  }

  void _detach() {
    _scrollToToday = null;
    _scrollToDate = null;
  }
}

/// 縦方向にスクロールするカレンダー。
///
/// 過去の日付を追加読み込みする機能を持つ。
/// 日記用であるため、未来の日付の追加読み込みは考慮していない。
class VerticalScrollCalendar extends StatefulWidget {
  /// [VerticalScrollCalendar] constructor.
  const VerticalScrollCalendar({
    super.key,
    this.controller,
    required this.dateItemBuilder,
    required this.separatorBuilder,
  });

  /// カレンダーのスクロール位置を制御するコントローラー。
  final ScrollCalendarController? controller;

  /// 日付ごとの Widget を生成するコールバック関数。
  final Widget Function(BuildContext, DateTime) dateItemBuilder;

  /// 日付の間に挿入するセパレーターを生成するコールバック関数。
  final Widget Function(BuildContext, int)? separatorBuilder;

  @override
  State<VerticalScrollCalendar> createState() => _VerticalScrollCalendarState();
}

class _VerticalScrollCalendarState extends State<VerticalScrollCalendar> {
  /// 現在の日時。
  final now = clock.now();

  /// カレンダーに表示する日付一覧。
  late List<DateTime> dates = now.datesInMonths(-1, 0);

  /// 逆順の日付一覧。
  ///
  /// ListView が `reverse: true` になっているため、
  /// 日付の昇順になるようにリストを逆順にする。
  List<DateTime> get _reversedDates => dates.reversed.toList();

  /// [ScrollablePositionedList] のスクロール位置を制御するコントローラー。
  final _itemScrollController = ItemScrollController();

  /// 初回のスクロール位置。
  late final int _initialScrollIndex;

  /// スクロール可能なカレンダーを制御するコントローラー。
  late final ScrollCalendarController _fallbackScrollCalendarController;
  ScrollCalendarController get _effectiveScrollCalendarController =>
      widget.controller ?? _fallbackScrollCalendarController;

  @override
  void initState() {
    super.initState();
    // 初回のスクロール位置を設定する。
    _initialScrollIndex = _reversedDates.indexWhere(
      (date) => DateUtils.isSameDay(date, clock.now()),
    );
    if (widget.controller == null) {
      _fallbackScrollCalendarController = ScrollCalendarController();
    }
    _effectiveScrollCalendarController._attach(
      scrollToToday: _scrollToToday,
      scrollToDate: _scrollToDate,
    );
  }

  @override
  void dispose() {
    _effectiveScrollCalendarController._detach();
    super.dispose();
  }

  /// 過去の日付を読み込む。
  void _loadMoreOlder() {
    final firstDate = dates.first;
    final previousDate = firstDate.subtract(const Duration(days: 1));
    setState(() {
      dates = [...previousDate.datesInMonth, ...dates];
    });
  }

  /// 今日の日付にスクロールする。
  Future<void> _scrollToToday({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) async {
    await _itemScrollController.scrollTo(
      index: _reversedDates.indexWhere((d) => DateUtils.isSameDay(d, now)),
      duration: duration,
      curve: curve,
    );
  }

  /// 指定した日付にスクロールする。
  Future<void> _scrollToDate(
    DateTime date, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) async {
    await _itemScrollController.scrollTo(
      index: _reversedDates.indexWhere((d) => DateUtils.isSameDay(d, date)),
      duration: duration,
      curve: curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      itemScrollController: _itemScrollController,
      // 追加読み込み中のローディングインジケーターを表示するために、
      // 1つ余分にアイテムを表示している。
      itemCount: _reversedDates.length + 1,
      initialScrollIndex: _initialScrollIndex,
      initialAlignment: 0.5,
      // 一番上までスクロールした時に追加読み込みを行う際に、
      // スクロール位置が変わらないようにするために `reverse: true` を指定している。
      reverse: true,
      // 月の初日や最終日にジャンプする際に異常なバウンスが発生しないように
      // `ClampingScrollPhysics` を使用している。
      physics: const ClampingScrollPhysics(),
      separatorBuilder: widget.separatorBuilder,
      itemBuilder: (_, index) {
        if (index == _reversedDates.length) {
          return EndItem(onScrollEnd: _loadMoreOlder);
        }
        final date = _reversedDates[index];
        return widget.dateItemBuilder(context, date);
      },
    );
  }
}

/// A widget that triggers a callback when it is visible.
class EndItem extends StatelessWidget {
  /// [EndItem] constructor.
  const EndItem({
    super.key,
    required void Function() onScrollEnd,
  }) : _onScrollEnd = onScrollEnd;

  /// The callback to be triggered when the item is visible.
  final VoidCallback _onScrollEnd;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: key ?? const Key('EndItem'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) {
          _onScrollEnd();
        }
      },
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: centerLoadingIndicator,
        ),
      ),
    );
  }
}
