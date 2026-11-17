import 'package:clock/clock.dart';
import 'package:intl/intl.dart';

import 'models/models.dart';

/// {@template exporter.ExportPeriod}
/// The dates that an export covers, which give the title of the export and
/// the date part of its file name.
/// {@endtemplate}
sealed class ExportPeriod {
  /// {@macro exporter.ExportPeriod}
  const new();

  /// The month of [year] and [month].
  factory month(int year, int month) => _Month(DateTime(year, month));

  /// The months from the first to the last of [entries], or the current
  /// month when [entries] is empty.
  factory ofEntries(List<ExportDiary> entries) {
    if (entries.isEmpty) {
      return _Month(clock.now());
    }

    final dates = entries.map((e) => e.date).toList()..sort();
    final firstDate = dates.first;
    final lastDate = dates.last;

    if (firstDate.year == lastDate.year && firstDate.month == lastDate.month) {
      return _Month(firstDate);
    }
    return _Months(firstDate, lastDate);
  }

  /// The days from [startDate] to [endDate].
  factory dateRange(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      if (startDate.day == endDate.day) {
        return _Day(startDate);
      }
      return _Month(startDate);
    }
    return _Days(startDate, endDate);
  }

  /// The title of the export, with the dates written for [locale].
  String title(String locale);

  /// The dates in the file name, written the same in every language.
  String get fileNamePart;
}

final class _Day extends ExportPeriod {
  const new(this.date);

  final DateTime date;

  @override
  String title(String locale) => DateFormat.yMMMEd(locale).format(date);

  @override
  String get fileNamePart => DateFormat('yyyy-MM-dd').format(date);
}

final class _Month extends ExportPeriod {
  const new(this.date);

  final DateTime date;

  @override
  String title(String locale) => DateFormat.yMMMM(locale).format(date);

  @override
  String get fileNamePart => DateFormat('yyyy-MM').format(date);
}

final class _Months extends ExportPeriod {
  const new(this.firstDate, this.lastDate);

  final DateTime firstDate;
  final DateTime lastDate;

  @override
  String title(String locale) {
    final format = DateFormat.yMMMM(locale);
    return '${format.format(firstDate)} - ${format.format(lastDate)}';
  }

  @override
  String get fileNamePart {
    final format = DateFormat('yyyy-MM');
    return '${format.format(firstDate)}_${format.format(lastDate)}';
  }
}

final class _Days extends ExportPeriod {
  const new(this.startDate, this.endDate);

  final DateTime startDate;
  final DateTime endDate;

  @override
  String title(String locale) {
    final format = DateFormat.yMMMd(locale);
    return '${format.format(startDate)} - ${format.format(endDate)}';
  }

  @override
  String get fileNamePart {
    final format = DateFormat('yyyy-MM-dd');
    return '${format.format(startDate)}_${format.format(endDate)}';
  }
}
