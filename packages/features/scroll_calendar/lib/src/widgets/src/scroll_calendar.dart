import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../extension/extension.dart';

/// Type definition for a function that scrolls to today's date.
///
/// - [duration] : The duration of the scroll animation.
/// - [curve] : The easing curve of the scroll animation.
typedef ScrollToTodayCallback =
    Future<void> Function({required Duration duration, required Curve curve});

/// Type definition for a function that scrolls to a specified date.
///
/// - [date] : The target date to scroll to.
/// - [duration] : The duration of the scroll animation.
/// - [curve] : The easing curve of the scroll animation.
typedef ScrollToDateCallback =
    Future<void> Function(
      DateTime date, {
      required Duration duration,
      required Curve curve,
    });

/// Type definition for a function that highlights a specified date.
///
/// - [date] : The target date to highlight.
/// - [duration] : The duration of the highlight animation.
typedef HighlightDateCallback =
    Future<void> Function(
      DateTime date, {
      required Duration duration,
    });

/// {@template scroll_calendar.ScrollCalendarController}
/// Controller for a scrollable calendar.
///
/// ### Corresponding ScrollCalendar
/// - [VerticalScrollCalendar]
/// {@endtemplate}
class ScrollCalendarController {
  /// {@macro scroll_calendar.ScrollCalendarController}
  ScrollCalendarController();

  ScrollToTodayCallback? _scrollToToday;
  ScrollToDateCallback? _scrollToDate;
  HighlightDateCallback? _highlightDate;

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

  /// Highlights the specified date with an animation.
  ///
  /// - [date] : The target date to highlight.
  /// - [duration] : The duration of the highlight animation.
  ///   Defaults to 400 milliseconds.
  Future<void> highlightDate(
    DateTime date, {
    Duration duration = const Duration(milliseconds: 400),
  }) async {
    assert(
      _highlightDate != null,
      'The controller is not attached to any ScrollCalendar.',
    );
    await _highlightDate?.call(date, duration: duration);
  }

  /// Attaches the controller to a [VerticalScrollCalendar].
  ///
  /// - [scrollToToday] : Callback function to scroll to today's date.
  /// - [scrollToDate] : Callback function to scroll to a specified date.
  /// - [highlightDate] : Callback function to highlight a specified date.
  @visibleForTesting
  void attach({
    required ScrollToTodayCallback scrollToToday,
    required ScrollToDateCallback scrollToDate,
    required HighlightDateCallback highlightDate,
  }) {
    assert(
      _scrollToToday == null && _scrollToDate == null && _highlightDate == null,
    );
    _scrollToToday = scrollToToday;
    _scrollToDate = scrollToDate;
    _highlightDate = highlightDate;
  }

  /// Detaches the controller from a [VerticalScrollCalendar].
  ///
  /// Clears the callback functions.
  @visibleForTesting
  void detach() {
    _scrollToToday = null;
    _scrollToDate = null;
    _highlightDate = null;
  }
}

/// {@template scroll_calendar.VerticalScrollCalendar}
/// A vertically scrollable calendar.
///
/// This calendar supports loading past dates incrementally.
/// It is designed for diary use, so loading future dates is not considered.
/// {@endtemplate}
class VerticalScrollCalendar extends StatefulWidget {
  /// {@macro scroll_calendar.VerticalScrollCalendar}
  const VerticalScrollCalendar({
    super.key,
    this.controller,
    required this.dates,
    required this.loadMoreOlder,
    required this.onVisibleDateChanged,
    required this.loadingIndicator,
    required this.dateItemBuilder,
    required this.separatorBuilder,
  });

  /// Controller to manage the scroll position of the calendar.
  final ScrollCalendarController? controller;

  /// List of dates to be displayed in the calendar.
  final List<DateTime> dates;

  /// Callback function to load more past dates.
  final VoidCallback loadMoreOlder;

  /// Callback function to handle the visibility of the calendar.
  final ValueChanged<DateTime> onVisibleDateChanged;

  /// The loading indicator to be displayed at the end of the list.
  final Widget loadingIndicator;

  /// Callback function to build a widget for each date.
  final Widget Function(BuildContext, DateTime) dateItemBuilder;

  /// Callback function to build a separator widget between dates.
  final Widget Function(BuildContext, DateTime) separatorBuilder;

  @override
  State<VerticalScrollCalendar> createState() => _VerticalScrollCalendarState();
}

class _VerticalScrollCalendarState extends State<VerticalScrollCalendar>
    with TickerProviderStateMixin {
  /// The current date and time.
  final DateTime now = clock.now();

  /// List of dates in reverse order.
  ///
  /// The ListView is set to `reverse: true`,
  /// so the list is reversed to display dates in ascending order.
  List<DateTime> get _reversedDates => widget.dates.reversed.toList();

  /// Controller to manage the scroll position of the
  /// [ScrollablePositionedList].
  final _itemScrollController = ItemScrollController();

  /// Listener to detect the visibility of items in the
  /// [ScrollablePositionedList].
  final _itemPositionsListener = ItemPositionsListener.create();

  /// Initial scroll position.
  late final int _initialScrollIndex;

  /// Fallback controller to manage the scroll position of the calendar.
  late final ScrollCalendarController _fallbackScrollCalendarController;
  ScrollCalendarController get _effectiveScrollCalendarController =>
      widget.controller ?? _fallbackScrollCalendarController;

  /// The index of the middle visible item.
  int? _middleVisibleIndex;

  /// The currently highlighted date.
  DateTime? _highlightedDate;

  /// Animation controller for highlight effect.
  late AnimationController _highlightAnimationController;

  /// Animation for highlight effect.
  late Animation<double> _highlightAnimation;

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

    // Initialize animation controller
    _highlightAnimationController = AnimationController(vsync: this);
    _highlightAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_highlightAnimationController);

    _effectiveScrollCalendarController.attach(
      scrollToToday: _scrollToToday,
      scrollToDate: _scrollToDate,
      highlightDate: _highlightDate,
    );
    _itemPositionsListener.itemPositions.addListener(_onItemPositionsChanged);
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(
      _onItemPositionsChanged,
    );
    _highlightAnimationController.dispose();
    _effectiveScrollCalendarController.detach();
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
      alignment: _indexAlignment,
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
      alignment: _indexAlignment,
      duration: duration,
      curve: curve,
    );
  }

  /// Highlights the specified date with an animation.
  ///
  /// - [date] : The target date to highlight.
  /// - [duration] : The duration of the highlight animation.
  ///   Defaults to 400 milliseconds.
  Future<void> _highlightDate(
    DateTime date, {
    required Duration duration,
  }) async {
    setState(() {
      _highlightedDate = date;
    });

    _highlightAnimationController.duration = duration;
    await _highlightAnimationController.forward();
    await _highlightAnimationController.reverse();

    setState(() {
      _highlightedDate = null;
    });
  }

  /// Callback function to handle the visibility of items in the list.
  void _onItemPositionsChanged() {
    final positions = _itemPositionsListener.itemPositions.value.toList();
    if (positions.isEmpty) {
      return;
    }
    // NOTE: When scrolling quickly, the order of positions may change,
    // so sort by index before processing.
    // https://github.com/google/flutter.widgets/issues/541#issuecomment-2370315790
    positions.sort((a, b) => a.index.compareTo(b.index));
    final middleVisibleIndex = positions[positions.length ~/ 2].index;
    if (middleVisibleIndex == _reversedDates.length) {
      return;
    }
    if (middleVisibleIndex == _middleVisibleIndex) {
      return;
    }
    _middleVisibleIndex = middleVisibleIndex;
    final visibleDate = _reversedDates[middleVisibleIndex];
    widget.onVisibleDateChanged(visibleDate);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ScrollablePositionedList.separated(
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      // Display one extra item to show a loading indicator
      // while loading more items.
      itemCount: _reversedDates.length + 1,
      initialScrollIndex: _initialScrollIndex,
      initialAlignment: _indexAlignment,
      // Set `reverse: true` to prevent scroll position changes
      // when loading more items at the top.
      reverse: true,
      padding: const EdgeInsets.only(bottom: 80),
      separatorBuilder: (_, index) {
        if (index == _reversedDates.length) {
          return const SizedBox.shrink();
        }
        final date = _reversedDates[index];
        return widget.separatorBuilder(context, date);
      },
      itemBuilder: (_, index) {
        if (index == _reversedDates.length) {
          return _EndItem(
            loadingIndicator: widget.loadingIndicator,
            onScrollEnd: widget.loadMoreOlder,
          );
        }
        final date = _reversedDates[index];
        final isHighlighted =
            _highlightedDate != null &&
            DateUtils.isSameDay(_highlightedDate, date);
        return AnimatedBuilder(
          animation: _highlightAnimation,
          builder: (context, child) {
            final value = isHighlighted ? _highlightAnimation.value : 0.0;
            return Transform.scale(
              scale: 1.0 + (0.02 * value),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: value > 0 ? colorScheme.surface : null,
                  borderRadius: BorderRadius.circular(12 * value),
                  boxShadow: value > 0
                      ? [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(
                              alpha: 0.08 * value,
                            ),
                            blurRadius: 16 * value,
                            offset: Offset(0, 2 * value),
                          ),
                        ]
                      : null,
                ),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DateItem(date: date),
                const Gap(16),
                Expanded(child: widget.dateItemBuilder(context, date)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// {@template scroll_calendar._DateItem}
/// A widget that displays a date.
/// {@endtemplate}
class _DateItem extends StatelessWidget {
  /// {@macro scroll_calendar._DateItem}
  const _DateItem({required this.date});

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
          date.shortWeekday(locale),
          style: textTheme.bodyMedium?.copyWith(color: dateColor),
        ),
        Text(
          date.day.toString().padLeft(2, '0'),
          style: textTheme.headlineSmall?.copyWith(color: dateColor),
        ),
      ],
    );
  }
}

/// {@template scroll_calendar._EndItem}
/// A widget that triggers a callback when it is visible.
/// {@endtemplate}
class _EndItem extends StatelessWidget {
  /// {@macro scroll_calendar._EndItem}
  const _EndItem({
    required this.loadingIndicator,
    required void Function() onScrollEnd,
  }) : _onScrollEnd = onScrollEnd;

  /// The loading indicator to be displayed.
  final Widget loadingIndicator;

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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: loadingIndicator,
        ),
      ),
    );
  }
}
