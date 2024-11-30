import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:widgets/widgets.dart';

import '../../extension/extension.dart';

/// Type definition for a function that scrolls to today's date.
///
/// - [duration] : The duration of the scroll animation.
/// - [curve] : The easing curve of the scroll animation.
typedef ScrollToTodayCallback = Future<void> Function({
  Duration duration,
  Curve curve,
});

/// Type definition for a function that scrolls to a specified date.
///
/// - [date] : The target date to scroll to.
/// - [duration] : The duration of the scroll animation.
/// - [curve] : The easing curve of the scroll animation.
typedef ScrollToDateCallback = Future<void> Function(
  DateTime date, {
  Duration duration,
  Curve curve,
});

/// Controller for a scrollable calendar.
///
/// ### Corresponding ScrollCalendar
/// - [VerticalScrollCalendar]
class ScrollCalendarController {
  /// [ScrollCalendarController] constructor.
  ScrollCalendarController();

  ScrollToTodayCallback? _scrollToToday;
  ScrollToDateCallback? _scrollToDate;

  /// Scrolls to today's date.
  ///
  /// - [duration] : The duration of the scroll animation.
  ///   Defaults to 500 milliseconds.
  /// - [curve] : The easing curve of the scroll animation.
  ///   Defaults to [Curves.easeInOut].
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

  /// Scrolls to the specified date.
  ///
  /// - [date] : The target date to scroll to.
  /// - [duration] : The duration of the scroll animation.
  ///   Defaults to 500 milliseconds.
  /// - [curve] : The easing curve of the scroll animation.
  ///   Defaults to [Curves.easeInOut].
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

/// A vertically scrollable calendar.
///
/// This calendar supports loading past dates incrementally.
/// It is designed for diary use, so loading future dates is not considered.
class VerticalScrollCalendar extends StatefulWidget {
  /// [VerticalScrollCalendar] constructor.
  const VerticalScrollCalendar({
    super.key,
    this.controller,
    required this.dates,
    required this.loadMoreOlder,
    required this.dateItemBuilder,
    required this.separatorBuilder,
  });

  /// Controller to manage the scroll position of the calendar.
  final ScrollCalendarController? controller;

  /// List of dates to be displayed in the calendar.
  final List<DateTime> dates;

  /// Callback function to load more past dates.
  final VoidCallback loadMoreOlder;

  /// Callback function to build a widget for each date.
  final Widget Function(BuildContext, DateTime) dateItemBuilder;

  /// Callback function to build a separator widget between dates.
  final Widget Function(BuildContext, int) separatorBuilder;

  @override
  State<VerticalScrollCalendar> createState() => _VerticalScrollCalendarState();
}

class _VerticalScrollCalendarState extends State<VerticalScrollCalendar> {
  /// The current date and time.
  final now = clock.now();

  /// List of dates in reverse order.
  ///
  /// The ListView is set to `reverse: true`,
  /// so the list is reversed to display dates in ascending order.
  List<DateTime> get _reversedDates => widget.dates.reversed.toList();

  /// Controller to manage the scroll position of the
  /// [ScrollablePositionedList].
  final _itemScrollController = ItemScrollController();

  /// Initial scroll position.
  late final int _initialScrollIndex;

  /// Fallback controller to manage the scroll position of the calendar.
  late final ScrollCalendarController _fallbackScrollCalendarController;
  ScrollCalendarController get _effectiveScrollCalendarController =>
      widget.controller ?? _fallbackScrollCalendarController;

  @override
  void initState() {
    super.initState();
    // Set the initial scroll position.
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

  /// Returns the alignment of the specified index.
  ///
  /// Ensures that today's date is displayed around the middle of the viewport.
  /// If fixed at 0.5, abnormal bouncing occurs when today's date is near
  /// the beginning or end of the month.
  /// Adjusts the value if near the beginning or end of the list,
  /// otherwise sets it to 0.5.
  double get _indexAlignment {
    final length = _reversedDates.length;
    if (_initialScrollIndex <= 4) {
      return _initialScrollIndex * 0.1;
    } else if (_initialScrollIndex >= length - 5) {
      return 1.0 - (length - 1 - _initialScrollIndex) * 0.1;
    }
    return 0.5;
  }

  /// Scrolls to today's date.
  ///
  /// - [duration] : The duration of the scroll animation.
  ///   Defaults to 500 milliseconds.
  /// - [curve] : The easing curve of the scroll animation.
  ///   Defaults to [Curves.easeInOut].
  Future<void> _scrollToToday({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) async {
    await _itemScrollController.scrollTo(
      index: _reversedDates.indexWhere((d) => DateUtils.isSameDay(d, now)),
      alignment: 0.5,
      duration: duration,
      curve: curve,
    );
  }

  /// Scrolls to the specified date.
  ///
  /// - [date] : The target date to scroll to.
  /// - [duration] : The duration of the scroll animation.
  ///   Defaults to 500 milliseconds.
  /// - [curve] : The easing curve of the scroll animation.
  ///   Defaults to [Curves.easeInOut].
  Future<void> _scrollToDate(
    DateTime date, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.easeInOut,
  }) async {
    await _itemScrollController.scrollTo(
      index: _reversedDates.indexWhere((d) => DateUtils.isSameDay(d, date)),
      alignment: 0.5,
      duration: duration,
      curve: curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.separated(
      itemScrollController: _itemScrollController,
      // Display one extra item to show a loading indicator
      // while loading more items.
      itemCount: _reversedDates.length + 1,
      initialScrollIndex: _initialScrollIndex,
      initialAlignment: _indexAlignment,
      // Set `reverse: true` to prevent scroll position changes
      // when loading more items at the top.
      reverse: true,
      // Use `ClampingScrollPhysics` to prevent abnormal bouncing
      // when jumping to the first or last day of the month.
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 80),
      separatorBuilder: widget.separatorBuilder,
      itemBuilder: (_, index) {
        if (index == _reversedDates.length) {
          return _EndItem(onScrollEnd: widget.loadMoreOlder);
        }
        final date = _reversedDates[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DateItem(date: date),
              const Gap(16),
              Expanded(
                child: widget.dateItemBuilder(context, date),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A widget that displays a date.
class _DateItem extends StatelessWidget {
  const _DateItem({
    required this.date,
  });

  /// The date to be displayed.
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateColor = date.isToday ? colorScheme.primary : null;
    return Column(
      children: [
        Text(
          '${date.year}',
          style: textTheme.bodySmall?.copyWith(
            color: dateColor,
          ),
        ),
        Text(
          date.month.toString().padLeft(2, '0'),
          style: textTheme.titleLarge?.copyWith(
            color: dateColor,
            height: 1,
            fontFamily: 'NotoSansJP',
          ),
        ),
        Text(
          date.day.toString().padLeft(2, '0'),
          style: textTheme.titleLarge?.copyWith(
            color: dateColor,
            height: 1,
            fontFamily: 'NotoSansJP',
          ),
        ),
        Text(
          date.shortWeekday(locale),
          style: textTheme.bodySmall?.copyWith(
            color: dateColor,
          ),
        ),
      ],
    );
  }
}

/// A widget that triggers a callback when it is visible.
class _EndItem extends StatelessWidget {
  /// [_EndItem] constructor.
  const _EndItem({
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
