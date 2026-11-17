import 'dart:io';

import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'export_period.dart';
import 'exporter.dart';
import 'models/models.dart';

/// {@template exporter.MarkdownExporter}
/// Exports diary entries to Markdown format.
/// {@endtemplate}
class MarkdownExporter extends Exporter {
  /// {@macro exporter.MarkdownExporter}
  const new({
    required this.packageInfo,
    required this.locale,
    required this.noEntryText,
    required this.exportedFromText,
  });

  /// Package information for metadata.
  final PackageInfo packageInfo;

  /// The locale of the dates, in the language of the app.
  final String locale;

  /// The text for a day without an entry, in the language of the app.
  final String noEntryText;

  /// The line that names the app and the version that exported the file, in
  /// the language of the app.
  final String Function({required Object appName, required Object version})
  exportedFromText;

  @override
  Future<File> export({
    required List<ExportDiary> entries,
  }) async {
    final period = ExportPeriod.ofEntries(entries);
    final fileName = _generateFileName(period);
    final content = _generateMarkdownContent(entries, period.title(locale));

    return _saveToFile(content, fileName);
  }

  @override
  Future<File> exportMonth({
    required List<ExportDiary> entries,
    required int year,
    required int month,
  }) async {
    final filteredEntries = entries.where((entry) {
      return entry.date.year == year && entry.date.month == month;
    }).toList();

    final period = ExportPeriod.month(year, month);
    final fileName = _generateFileName(period);
    final content = _generateMarkdownContentForMonth(
      filteredEntries,
      period.title(locale),
      year,
      month,
    );

    return _saveToFile(content, fileName);
  }

  @override
  Future<File> exportDateRange({
    required List<ExportDiary> entries,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final filteredEntries = entries.where((entry) {
      final entryDate = entry.date;
      return entryDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    final period = ExportPeriod.dateRange(startDate, endDate);
    final fileName = _generateFileName(period);
    final content = _generateMarkdownContent(
      filteredEntries,
      period.title(locale),
    );

    return _saveToFile(content, fileName);
  }

  String _generateMarkdownContent(List<ExportDiary> entries, String title) {
    final buffer = StringBuffer()
      ..writeln('# $title')
      ..writeln()
      ..writeln(
        exportedFromText(
          appName: packageInfo.appName,
          version: packageInfo.version,
        ),
      )
      ..writeln(DateFormat.yMMMd(locale).add_jm().format(clock.now()))
      ..writeln()
      ..writeln('---')
      ..writeln();

    final sortedEntries = entries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final entry in sortedEntries) {
      buffer
        ..writeln('## ${DateFormat.yMMMEd(locale).format(entry.date)}')
        ..writeln()
        ..writeln(entry.content)
        ..writeln();
    }

    return buffer.toString();
  }

  String _generateMarkdownContentForMonth(
    List<ExportDiary> entries,
    String title,
    int year,
    int month,
  ) {
    final buffer = StringBuffer()
      ..writeln('# $title')
      ..writeln()
      ..writeln(
        exportedFromText(
          appName: packageInfo.appName,
          version: packageInfo.version,
        ),
      )
      ..writeln(DateFormat.yMMMd(locale).add_jm().format(clock.now()))
      ..writeln()
      ..writeln('---')
      ..writeln();

    final daysInMonth = DateTime(year, month + 1, 0).day;
    final entryMap = <int, ExportDiary>{};

    for (final entry in entries) {
      if (entry.date.year == year && entry.date.month == month) {
        entryMap[entry.date.day] = entry;
      }
    }

    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      buffer
        ..writeln('## ${DateFormat.yMMMEd(locale).format(date)}')
        ..writeln();

      final entry = entryMap[day];
      if (entry != null && entry.content.isNotEmpty) {
        buffer.writeln(entry.content);
      } else {
        buffer.writeln(noEntryText);
      }

      buffer.writeln();
    }

    return buffer.toString();
  }

  String _generateFileName(ExportPeriod period) {
    final appName = packageInfo.appName.replaceAll(RegExp(r'[^\w\s-]'), '');
    final version = packageInfo.version;
    final timestamp = DateFormat('yyyyMMddHHmmss').format(
      clock.now(),
    );

    return '${appName}_${period.fileNamePart}_v$version-$timestamp.md';
  }

  Future<File> _saveToFile(String content, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(p.join(tempDir.path, fileName));

    await file.writeAsString(content);

    return file;
  }
}
