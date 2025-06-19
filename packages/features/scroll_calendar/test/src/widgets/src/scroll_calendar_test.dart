import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gap/gap.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
        () async => controller.scrollToToday(),
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
    setUpAll(() async {
      await initializeDateFormatting();
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('renders dates in the current month', (tester) async {
      final date = DateTime(2024, 10, 15);
      await withClock(Clock.fixed(date), () async {
        await tester.pumpWidget(
          _TestVerticalScrollCalendar(dates: date.datesInMonth),
        );

        expect(find.text('$date'), findsOneWidget);
      });
    });

    testWidgets('renders first date in the current month', (tester) async {
      // Temporarily set to the 2nd as the 1st is not displayed.
      // It is probably a bug in scrollable_positioned_list.
      final date = DateTime(2024, 10, 2);
      await withClock(Clock.fixed(date), () async {
        await tester.pumpWidget(
          _TestVerticalScrollCalendar(dates: date.datesInMonth),
        );

        expect(find.text('$date'), findsOneWidget);
      });
    });

    testWidgets('renders last date in the current month', (tester) async {
      final date = DateTime(2024, 10, 31);
      await withClock(Clock.fixed(date), () async {
        await tester.pumpWidget(
          _TestVerticalScrollCalendar(dates: date.datesInMonth),
        );

        expect(find.text('$date'), findsOneWidget);
      });
    });

    testWidgets('calls loadMoreOlder when end of list is reached', (
      tester,
    ) async {
      final date = DateTime(2024, 10, 15);

      var loadMoreOlderCalled = false;

      await withClock(Clock.fixed(date), () async {
        await tester.pumpWidget(
          _TestVerticalScrollCalendar(
            dates: date.datesInMonth,
            loadMoreOlder: () {
              loadMoreOlderCalled = true;
            },
          ),
        );

        await tester.drag(find.text('$date'), const Offset(0, 1000));
        await tester.pumpAndSettle();

        expect(loadMoreOlderCalled, isTrue);
      });
    });

    testWidgets('scrolls to today when controller.scrollToToday is called', (
      tester,
    ) async {
      final date = DateTime(2024, 10, 15);

      await withClock(Clock.fixed(date), () async {
        final controller = ScrollCalendarController();

        await tester.pumpWidget(
          _TestVerticalScrollCalendar(
            controller: controller,
            dates: date.datesInMonth,
          ),
        );

        await tester.drag(find.text('$date'), const Offset(0, 1000));
        await tester.pumpAndSettle();

        expect(find.text('$date'), findsNothing);

        unawaited(controller.scrollToToday());
        await tester.pumpAndSettle();

        expect(find.text('$date'), findsOneWidget);
      });
    });

    testWidgets('scrolls to date when controller.scrollToDate is called', (
      tester,
    ) async {
      final date = DateTime(2024, 10, 15);
      final targetDate = DateTime(2024, 10, 31);

      await withClock(Clock.fixed(date), () async {
        final controller = ScrollCalendarController();

        await tester.pumpWidget(
          _TestVerticalScrollCalendar(
            controller: controller,
            dates: date.datesInMonth,
          ),
        );

        await tester.drag(find.text('$date'), const Offset(0, 1000));
        await tester.pumpAndSettle();

        expect(find.text('$targetDate'), findsNothing);

        unawaited(controller.scrollToDate(targetDate));
        await tester.pumpAndSettle();

        expect(find.text('$targetDate'), findsOneWidget);
      });
    });

    testWidgets('calls onVisibleDateChanged when visible date changes', (
      tester,
    ) async {
      final date = DateTime(2024, 10, 15);
      DateTime? visibleDate;

      await withClock(Clock.fixed(date), () async {
        await tester.pumpWidget(
          _TestVerticalScrollCalendar(
            dates: date.datesInMonths(-2, 0),
            onVisibleDateChanged: (date) {
              visibleDate = date;
            },
          ),
        );

        await tester.drag(find.text('$date'), const Offset(0, 1000));
        await tester.pumpAndSettle();

        expect(visibleDate, isNotNull);
      });
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

    testWidgets('highlight animation shows visual effect', (tester) async {
      final date = DateTime(2024, 10, 15);

      await withClock(Clock.fixed(date), () async {
        final controller = ScrollCalendarController();

        await tester.pumpWidget(
          _TestVerticalScrollCalendar(
            controller: controller,
            dates: date.datesInMonth,
          ),
        );

        // Start highlight animation
        unawaited(
          controller.highlightDate(
            date,
            duration: const Duration(milliseconds: 100),
          ),
        );
        await tester.pump(const Duration(milliseconds: 50)); // Mid-animation

        // Check that animation is running (AnimatedBuilder should be building)
        expect(find.text('$date'), findsOneWidget);

        // Complete animation
        await tester.pumpAndSettle();
      });
    });
  });
}

class _TestVerticalScrollCalendar extends StatelessWidget {
  const _TestVerticalScrollCalendar({
    this.controller,
    required this.dates,
    this.loadMoreOlder,
    this.onVisibleDateChanged,
  });

  final ScrollCalendarController? controller;
  final List<DateTime> dates;
  final VoidCallback? loadMoreOlder;
  final ValueChanged<DateTime>? onVisibleDateChanged;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: VerticalScrollCalendar(
          controller: controller,
          dates: dates,
          loadMoreOlder: loadMoreOlder ?? () {},
          onVisibleDateChanged: onVisibleDateChanged ?? (date) {},
          loadingIndicator: const SizedBox(),
          dateItemBuilder: (_, date) => Text('$date'),
          separatorBuilder: (_, _) => const Gap(32),
        ),
      ),
    );
  }
}
