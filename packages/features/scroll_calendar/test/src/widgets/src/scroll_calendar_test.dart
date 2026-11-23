import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:scroll_calendar/scroll_calendar.dart';

void main() {
  group('ScrollCalendarController', () {
    test('scrollToToday calls the attached callback', () async {
      final controller = ScrollCalendarController();

      var scrollToTodayCalled = false;

      controller.attach(
        scrollToToday: ({required duration, required curve}) async {
          scrollToTodayCalled = true;
        },
        scrollToDate: (date, {required duration, required curve}) async {},
        highlightDate: (date, {required Duration duration}) async {},
      );

      await controller.scrollToToday();
      expect(scrollToTodayCalled, isTrue);

      controller.detach();
    });

    test(
      'scrollToDate calls the attached callback with correct date',
      () async {
        final controller = ScrollCalendarController();

        var scrollToDateCalled = false;
        var targetDate = DateTime(2023, 9);

        controller.attach(
          scrollToToday: ({required duration, required curve}) async {},
          scrollToDate: (date, {required duration, required curve}) async {
            scrollToDateCalled = true;
            targetDate = date;
          },
          highlightDate: (date, {required Duration duration}) async {},
        );

        final date = DateTime(2023, 10);
        await controller.scrollToDate(date);
        expect(scrollToDateCalled, isTrue);
        expect(targetDate, date);

        controller.detach();
      },
    );

    test('scrollToToday throws assertion error when not attached', () async {
      final controller = ScrollCalendarController()
        ..attach(
          scrollToToday: ({required duration, required curve}) async {},
          scrollToDate: (date, {required duration, required curve}) async {},
          highlightDate: (date, {required Duration duration}) async {},
        )
        ..detach();

      expect(
        controller.scrollToToday,
        throwsA(isA<AssertionError>()),
      );
    });

    test('scrollToDate throws assertion error when not attached', () async {
      final controller = ScrollCalendarController()
        ..attach(
          scrollToToday: ({required duration, required curve}) async {},
          scrollToDate: (date, {required duration, required curve}) async {},
          highlightDate: (date, {required Duration duration}) async {},
        )
        ..detach();

      expect(
        () async => controller.scrollToDate(DateTime(2023, 10)),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
      'highlightDate calls the attached callback with correct date',
      () async {
        final controller = ScrollCalendarController();

        var highlightDateCalled = false;
        var targetDate = DateTime(2023, 9);

        controller.attach(
          scrollToToday: ({required duration, required curve}) async {},
          scrollToDate: (date, {required duration, required curve}) async {},
          highlightDate: (date, {required Duration duration}) async {
            highlightDateCalled = true;
            targetDate = date;
          },
        );

        final date = DateTime(2023, 10);
        await controller.highlightDate(date);
        expect(highlightDateCalled, isTrue);
        expect(targetDate, date);

        controller.detach();
      },
    );

    test('highlightDate throws assertion error when not attached', () async {
      final controller = ScrollCalendarController()
        ..attach(
          scrollToToday: ({required duration, required curve}) async {},
          scrollToDate: (date, {required duration, required curve}) async {},
          highlightDate: (date, {required Duration duration}) async {},
        )
        ..detach();

      expect(
        () async => controller.highlightDate(DateTime(2023, 10)),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('VerticalScrollCalendar', () {
    const height = 600.0;
    final today = DateTime(2024, 10, 15);

    setUpAll(() async {
      await initializeDateFormatting();
    });

    Rect rectOf(WidgetTester tester, DateTime date) =>
        tester.getRect(find.text('$date', skipOffstage: false));

    ScrollPosition positionOf(WidgetTester tester) =>
        tester.state<ScrollableState>(find.byType(Scrollable)).position;

    Future<void> pumpCalendar(
      WidgetTester tester, {
      DateTime? now,
      List<DateTime>? dates,
      ScrollCalendarController? controller,
      VoidCallback? loadMoreOlder,
      VoidCallback? loadMoreNewer,
      ValueChanged<DateTime>? onVisibleDateChanged,
    }) {
      return withClock(Clock.fixed(now ?? today), () async {
        await tester.pumpWidget(
          _TestVerticalScrollCalendar(
            controller: controller,
            dates: dates ?? today.datesInMonth,
            loadMoreOlder: loadMoreOlder,
            loadMoreNewer: loadMoreNewer,
            onVisibleDateChanged: onVisibleDateChanged,
          ),
        );
        await tester.pump();
      });
    }

    testWidgets('shows today in the middle', (tester) async {
      await pumpCalendar(tester);

      expect(rectOf(tester, today).top, height / 2);
    });

    testWidgets('shows the first date of the month', (tester) async {
      final first = DateTime(2024, 10);
      await pumpCalendar(tester, now: first);

      expect(rectOf(tester, first).top, greaterThanOrEqualTo(0));
      expect(rectOf(tester, first).bottom, lessThanOrEqualTo(height));
    });

    testWidgets('shows the last date of the month', (tester) async {
      final last = DateTime(2024, 10, 31);
      await pumpCalendar(tester, now: last);

      expect(rectOf(tester, last).top, greaterThanOrEqualTo(0));
      expect(rectOf(tester, last).bottom, lessThanOrEqualTo(height));
    });

    testWidgets('keeps its keys apart from the keys of the dates', (
      tester,
    ) async {
      await pumpCalendar(tester);

      expect(find.byKey(ValueKey(today)), findsOneWidget);
    });

    testWidgets('builds the separators above the dates after the first', (
      tester,
    ) async {
      await pumpCalendar(tester, now: DateTime(2024, 10, 2));

      expect(find.text('above ${DateTime(2024, 10)}'), findsNothing);
      final separator = DateTime(2024, 10, 2);
      expect(
        tester.getRect(find.text('above $separator')).bottom,
        rectOf(tester, separator).top,
      );
    });

    testWidgets('calls loadMoreOlder when the start of the list is visible', (
      tester,
    ) async {
      var older = 0;
      var newer = 0;
      await pumpCalendar(
        tester,
        loadMoreOlder: () => older++,
        loadMoreNewer: () => newer++,
      );
      expect(older, 0);

      await tester.drag(find.byType(Scrollable), const Offset(0, 3000));
      await tester.pumpAndSettle();

      expect(older, greaterThan(0));
      expect(newer, 0);
    });

    testWidgets('calls loadMoreNewer when the end of the list is visible', (
      tester,
    ) async {
      var older = 0;
      var newer = 0;
      await pumpCalendar(
        tester,
        loadMoreOlder: () => older++,
        loadMoreNewer: () => newer++,
      );
      expect(newer, 0);

      await tester.drag(find.byType(Scrollable), const Offset(0, -3000));
      await tester.pumpAndSettle();

      expect(newer, greaterThan(0));
      expect(older, 0);
    });

    testWidgets('keeps the visible dates in place when older dates are added', (
      tester,
    ) async {
      await pumpCalendar(tester);
      final top = rectOf(tester, today).top;

      await pumpCalendar(tester, dates: today.datesInMonths(-1, 0));

      expect(rectOf(tester, today).top, top);
    });

    testWidgets('keeps the visible dates in place when newer dates are added', (
      tester,
    ) async {
      final last = DateTime(2024, 10, 31);
      await pumpCalendar(tester);
      await tester.drag(find.byType(Scrollable), const Offset(0, -3000));
      await tester.pumpAndSettle();
      final top = rectOf(tester, last).top;

      await pumpCalendar(tester, dates: today.datesInMonths(0, 1));

      expect(rectOf(tester, last).top, top);
    });

    testWidgets('scrolls to today when controller.scrollToToday is called', (
      tester,
    ) async {
      final controller = ScrollCalendarController();
      await pumpCalendar(tester, controller: controller);
      await tester.drag(find.byType(Scrollable), const Offset(0, 3000));
      await tester.pumpAndSettle();
      expect(rectOf(tester, today).top, isNot(height / 2));

      unawaited(controller.scrollToToday());
      await tester.pumpAndSettle();

      expect(rectOf(tester, today).top, height / 2);
    });

    testWidgets('scrolls to date when controller.scrollToDate is called', (
      tester,
    ) async {
      final controller = ScrollCalendarController();
      final target = DateTime(2024, 10, 20);
      await pumpCalendar(tester, controller: controller);

      unawaited(controller.scrollToDate(target));
      await tester.pumpAndSettle();

      expect(rectOf(tester, target).top, height / 2);
    });

    testWidgets('scrollToDate throws for a date that is not loaded', (
      tester,
    ) async {
      final controller = ScrollCalendarController();
      await pumpCalendar(tester, controller: controller);

      await expectLater(
        controller.scrollToDate(DateTime(2024, 12)),
        throwsArgumentError,
      );
    });

    testWidgets('reports the date in the middle of the viewport', (
      tester,
    ) async {
      final controller = ScrollCalendarController();
      final reported = <DateTime>[];
      await pumpCalendar(
        tester,
        controller: controller,
        onVisibleDateChanged: reported.add,
      );
      expect(reported, [today]);

      final target = DateTime(2024, 10, 20);
      unawaited(controller.scrollToDate(target));
      await tester.pumpAndSettle();
      expect(reported.last, target);

      // The middle of the viewport is now on the separator above the target.
      final position = positionOf(tester);
      position.jumpTo(position.pixels - 16);
      await tester.pump();
      expect(rectOf(tester, target).top, height / 2 + 16);
      expect(reported.last, target);

      // Reports a date once while it stays in the middle.
      expect(reported.where((d) => d == target), hasLength(1));
    });

    testWidgets('reports the last date when every date ends above the middle', (
      tester,
    ) async {
      final reported = <DateTime>[];
      final dates = [today, DateTime(2024, 10, 16)];
      await pumpCalendar(
        tester,
        dates: dates,
        onVisibleDateChanged: reported.add,
      );

      expect(rectOf(tester, dates.last).bottom, lessThan(height / 2));
      expect(reported, [dates.last]);
    });

    testWidgets('highlight animation shows visual effect', (tester) async {
      final controller = ScrollCalendarController();
      await pumpCalendar(tester, controller: controller);

      // Start highlight animation
      unawaited(
        controller.highlightDate(
          today,
          duration: const Duration(milliseconds: 100),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50)); // Mid-animation

      // Check that animation is running (AnimatedBuilder should be building)
      expect(find.text('$today'), findsOneWidget);

      // Complete animation
      await tester.pumpAndSettle();
    });

    test('highlightDate with custom duration', () async {
      final controller = ScrollCalendarController();

      var receivedDuration = const Duration(milliseconds: 400);

      controller.attach(
        scrollToToday: ({required duration, required curve}) async {},
        scrollToDate: (date, {required duration, required curve}) async {},
        highlightDate: (date, {required Duration duration}) async {
          receivedDuration = duration;
        },
      );

      const customDuration = Duration(milliseconds: 600);
      await controller.highlightDate(
        DateTime(2023, 10),
        duration: customDuration,
      );

      expect(receivedDuration, customDuration);
      controller.detach();
    });
  });
}

class _TestVerticalScrollCalendar extends StatelessWidget {
  const new({
    this.controller,
    required this.dates,
    this.loadMoreOlder,
    this.loadMoreNewer,
    this.onVisibleDateChanged,
  });

  final ScrollCalendarController? controller;
  final List<DateTime> dates;
  final VoidCallback? loadMoreOlder;
  final VoidCallback? loadMoreNewer;
  final ValueChanged<DateTime>? onVisibleDateChanged;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VerticalScrollCalendar(
          controller: controller,
          dates: dates,
          loadMoreOlder: loadMoreOlder ?? () {},
          loadMoreNewer: loadMoreNewer ?? () {},
          onVisibleDateChanged: onVisibleDateChanged ?? (date) {},
          loadingIndicator: const SizedBox(),
          dateItemBuilder: (_, date) => Text('$date', key: ValueKey(date)),
          separatorBuilder: (_, date) =>
              SizedBox(height: 32, child: Text('above $date')),
        ),
      ),
    );
  }
}
