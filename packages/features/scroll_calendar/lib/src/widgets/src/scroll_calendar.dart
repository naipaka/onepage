import 'package:anchor_list_view/anchor_list_view.dart';
import 'package:clock/clock.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '../../extension/extension.dart';

/// Type definition for a function that scrolls to today's date.
///
/// - [duration] : The duration of the scroll animation.
/// - [curve] : The easing curve of the scroll animation.
typedef ScrollToTodayCallback = Future<void> Function({
  required Duration duration,
  required Curve curve,
});

/// Type definition for a function that scrolls to a specified date.
///
/// - [date] : The target date to scroll to.
/// - [duration] : The duration of the scroll animation.
/// - [curve] : The easing curve of the scroll animation.
typedef ScrollToDateCallback = Future<void> Function(
  DateTime date, {
  required Duration duration,
  required Curve curve,
});

/// Type definition for a function that highlights a specified date.
///
/// - [date] : The target date to highlight.
/// - [duration] : The duration of the highlight animation.
typedef HighlightDateCallback = Future<void> Function(
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
  new();

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

  /// Scrolls to the specified date, which must be in the dates of the
  /// calendar.
  ///
  /// - [date] : The target date to scroll to.
  /// - [duration] : The duration of the scroll animation.
  ///   Defaults to 500 milliseconds.
  /// - [curve] : The easing curve of the scroll animation.
  ///   Defaults to [Curves.easeInOut].
  ///
  /// Throws an [ArgumentError] when the calendar does not have [date].
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
/// A vertically scrollable calendar of [dates] in ascending order.
///
/// It shows today in the middle first, and asks for more dates when either
/// end of the list is visible. Dates added before the visible dates keep
/// them in place.
/// {@endtemplate}
class VerticalScrollCalendar extends StatefulWidget {
  /// {@macro scroll_calendar.VerticalScrollCalendar}
  const new({
    super.key,
    this.controller,
    required this.dates,
    required this.loadMoreOlder,
    required this.loadMoreNewer,
    required this.onVisibleDateChanged,
    required this.loadingIndicator,
    required this.dateItemBuilder,
    required this.separatorBuilder,
  });

  /// Controller to manage the scroll position of the calendar.
  final ScrollCalendarController? controller;

  /// Consecutive dates to be displayed in the calendar, in ascending order.
  final List<DateTime> dates;

  /// Called while the start of the list is visible, to add older dates.
  final VoidCallback loadMoreOlder;

  /// Called while the end of the list is visible, to add newer dates.
  final VoidCallback loadMoreNewer;

  /// Called with the date in the middle of the viewport when it changes.
  ///
  /// When the middle of the viewport is between two dates, it is the date
  /// below.
  final ValueChanged<DateTime> onVisibleDateChanged;

  /// The loading indicator to be displayed at both ends of the list.
  final Widget loadingIndicator;

  /// Callback function to build a widget for each date.
  final Widget Function(BuildContext, DateTime) dateItemBuilder;

  /// Callback function to build the separator above each date except the
  /// first one.
  final Widget Function(BuildContext, DateTime) separatorBuilder;

  @override
  State<VerticalScrollCalendar> createState() => _VerticalScrollCalendarState();
}

class _VerticalScrollCalendarState extends State<VerticalScrollCalendar>
    with TickerProviderStateMixin {
  /// Where the calendar puts the dates it moves to, and the place of the
  /// visible date: the middle of the viewport.
  static const _alignment = 0.5;


  /// The current date and time.
  final DateTime now = clock.now();

  final _listController = AnchorListController();

  /// Fallback controller to manage the scroll position of the calendar.
  late final ScrollCalendarController _fallbackScrollCalendarController;
  ScrollCalendarController get _effectiveScrollCalendarController =>
      widget.controller ?? _fallbackScrollCalendarController;

  /// The date last reported to [VerticalScrollCalendar.onVisibleDateChanged].
  DateTime? _visibleDate;

  /// The currently highlighted date.
  DateTime? _highlightedDate;

  /// Animation controller for highlight effect.
  late AnimationController _highlightAnimationController;

  /// Animation for highlight effect.
  late Animation<double> _highlightAnimation;

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    _highlightAnimationController.dispose();
    _listController.dispose();
    _effectiveScrollCalendarController.detach();
    super.dispose();
  }

  /// The index of the item of [date] in the list, which starts with the
  /// loading indicator of older dates, or null when [date] is not loaded.
  int? _indexOf(DateTime date) {
    final index = widget.dates.indexWhere((d) => DateUtils.isSameDay(d, date));
    return index < 0 ? null : index + 1;
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
  }) {
    return _scrollToDate(now, duration: duration, curve: curve);
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
    final index = _indexOf(date);
    if (index == null) {
      throw ArgumentError.value(date, 'date', 'is not loaded');
    }
    await _listController.animateToItem(
      index,
      alignment: _alignment,
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

  /// Asks for more dates at a visible end of the list, and reports the date
  /// in the middle of the viewport.
  void _onPositionsChanged(List<AnchorItemPosition> positions) {
    final dates = widget.dates;
    if (positions.any((p) => p.index == 0)) {
      widget.loadMoreOlder();
    }
    if (positions.any((p) => p.index == dates.length + 1)) {
      widget.loadMoreNewer();
    }
    final visible = positions.where(
      (p) => p.index > 0 && p.index <= dates.length,
    );
    if (visible.isEmpty) {
      return;
    }
    final middle = visible.firstWhere(
      (p) => p.trailingEdge > _alignment,
      orElse: () => visible.last,
    );
    final date = dates[middle.index - 1];
    if (date == _visibleDate) {
      return;
    }
    _visibleDate = date;
    widget.onVisibleDateChanged(date);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dates = widget.dates;
    final indexes = {for (final (i, date) in dates.indexed) date: i + 1};
    return AnchorListView.separated(
      controller: _listController,
      // The loading indicators of older and newer dates are the first and the
      // last items.
      itemCount: dates.length + 2,
      initialIndex: _indexOf(now) ?? 0,
      initialAlignment: _alignment,
      findItemIndexCallback: (key) {
        return switch (key) {
          _LoadingKey.older => 0,
          _LoadingKey.newer => dates.length + 1,
          _DateKey(:final value) => indexes[value],
          _ => null,
        };
      },
      onPositionsChanged: _onPositionsChanged,
      padding: const EdgeInsets.only(bottom: 80),
      separatorBuilder: (context, index) {
        if (index == 0 || index == dates.length) {
          return const SizedBox.shrink();
        }
        return widget.separatorBuilder(context, dates[index]);
      },
      itemBuilder: (context, index) {
        if (index == 0 || index == dates.length + 1) {
          return Center(
            key: index == 0 ? _LoadingKey.older : _LoadingKey.newer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: widget.loadingIndicator,
            ),
          );
        }
        final date = dates[index - 1];
        final isHighlighted =
            _highlightedDate != null &&
            DateUtils.isSameDay(_highlightedDate, date);
        return KeyedSubtree(
          key: _DateKey(date),
          child: AnimatedBuilder(
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
          ),
        );
      },
    );
  }
}

/// The key of the item of a date, which differs from the keys that the
/// callers give to their widgets.
class _DateKey extends ValueKey<DateTime> {
  const new(super.value);
}

/// The keys of the loading indicators at the start and at the end of the
/// list.
class _LoadingKey extends ValueKey<String> {
  const new _(super.value);

  static const older = _LoadingKey._('older');
  static const newer = _LoadingKey._('newer');
}

/// {@template scroll_calendar._DateItem}
/// A widget that displays a date.
/// {@endtemplate}
class _DateItem extends StatelessWidget {
  /// {@macro scroll_calendar._DateItem}
  const new({required this.date});

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
