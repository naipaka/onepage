import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// For Calendar [DateTime] extension methods.
extension DateTimeExtensionForCalendar on DateTime {
  /// Get a list of dates for the target month.
  ///
  /// e.g. For `May 2024`, get a list of [DateTime]
  /// from `May 1, 2024` to `May 31, 2024`.
  List<DateTime> get datesInMonth {
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    return List.generate(
      lastDayOfMonth.day,
      (index) => DateTime(year, month, index + 1),
    );
  }

  /// Get a list of dates from [start] months
  /// before to [end] months after the target date.
  ///
  /// e.g. For `November 2024` with `start = -1` and `end = 1`,
  /// get a list of [DateTime] from `October 1, 2024` to `December 31, 2024`.
  List<DateTime> datesInMonths(int start, int end) {
    final dates = <DateTime>[];
    for (var i = start; i < end + 1; i++) {
      dates.addAll(DateTime(year, month + i).datesInMonth);
    }
    return dates;
  }

  /// Get the abbreviated weekday.
  ///
  /// e.g. `Tue`
  String shortWeekday(String locale) {
    if (locale == 'ja') {
      // For Japanese, get the weekday in English.
      return DateFormat.E('en').format(this);
    }
    return DateFormat.E(locale).format(this);
  }

  /// Checks if the current DateTime instance represents today's date.
  ///
  /// Returns `true` if the date is today, otherwise `false`.
  bool get isToday {
    final now = clock.now();
    return DateUtils.isSameDay(this, now);
  }
}
