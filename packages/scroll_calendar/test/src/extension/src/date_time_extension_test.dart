import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scroll_calendar/src/extension/src/date_time_extension.dart';

void main() {
  group('DateTimeExtensionForCalendar', () {
    setUpAll(() async {
      await initializeDateFormatting();
    });

    test('datesInMonth should return correct dates for a given month', () {
      final date = DateTime(2024, 5);
      final dates = date.datesInMonth;
      expect(dates.length, 31);
      expect(dates.first, DateTime(2024, 5));
      expect(dates.last, DateTime(2024, 5, 31));
    });

    test(
        'previousMonthDates should return correct dates for the previous month',
        () {
      final date = DateTime(2024, 5);
      final previousMonthDates = date.previousMonthDates;
      expect(previousMonthDates.length, 30);
      expect(previousMonthDates.first, DateTime(2024, 4));
      expect(previousMonthDates.last, DateTime(2024, 4, 30));
    });

    test('datesInMonths should return correct dates for a range of months', () {
      final date = DateTime(2024, 11);
      final dates = date.datesInMonths(-1, 1);
      expect(dates.first, DateTime(2024, 10));
      expect(dates.last, DateTime(2024, 12, 31));
    });

    test('shortWeekday should return correct abbreviated weekday', () {
      final date = DateTime(2024, 5);
      expect(date.shortWeekday('en'), 'Wed');
      expect(date.shortWeekday('ja'), 'Wed');
    });

    test('isToday should return true if the date is today', () {
      withClock(Clock.fixed(DateTime(2024, 5, 15)), () {
        final date = DateTime(2024, 5, 15);
        expect(date.isToday, isTrue);
      });
    });

    test('isToday should return false if the date is not today', () {
      withClock(Clock.fixed(DateTime(2024, 5, 15)), () {
        final date = DateTime(2024, 5, 16);
        expect(date.isToday, isFalse);
      });
    });
  });
}
