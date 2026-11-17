import 'dart:io';

import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'export_period.dart';
import 'exporter.dart';
import 'models/models.dart';
import 'untranslated_texts.dart';

/// {@template exporter.CsvExporter}
/// Exports diary entries to CSV format.
/// {@endtemplate}
class CsvExporter extends Exporter {
  /// {@macro exporter.CsvExporter}
  const new({
    required this.packageInfo,
  });

  /// Package information for metadata.
  final PackageInfo packageInfo;

  @override
  Future<File> export({
    required List<ExportDiary> entries,
  }) async {
    final fileName = _generateFileName(ExportPeriod.ofEntries(entries));
    final content = _generateCsvContent(entries);

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

    final fileName = _generateFileName(ExportPeriod.month(year, month));
    final content = _generateCsvContentForMonth(filteredEntries, year, month);

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

    final fileName = _generateFileName(
      ExportPeriod.dateRange(startDate, endDate),
    );
    final content = _generateCsvContent(filteredEntries);

    return _saveToFile(content, fileName);
  }

  String _generateCsvContent(List<ExportDiary> entries) {
    final buffer = StringBuffer()..writeln(UntranslatedTexts.csvHeader);

    final sortedEntries = entries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final entry in sortedEntries) {
      final dateStr = DateFormat('yyyy-MM-dd').format(entry.date);
      final escapedContent = _escapeCsvField(entry.content);
      buffer.writeln('$dateStr,$escapedContent');
    }

    return buffer.toString();
  }

  String _generateCsvContentForMonth(
    List<ExportDiary> entries,
    int year,
    int month,
  ) {
    final buffer = StringBuffer()..writeln(UntranslatedTexts.csvHeader);

    final daysInMonth = DateTime(year, month + 1, 0).day;
    final entryMap = <int, ExportDiary>{};

    for (final entry in entries) {
      if (entry.date.year == year && entry.date.month == month) {
        entryMap[entry.date.day] = entry;
      }
    }

    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final entry = entryMap[day];
      final content = entry?.content ?? '';
      final escapedContent = _escapeCsvField(content);
      buffer.writeln('$dateStr,$escapedContent');
    }

    return buffer.toString();
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') ||
        field.contains('"') ||
        field.contains('\n') ||
        field.contains('\r')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  String _generateFileName(ExportPeriod period) {
    final appName = packageInfo.appName.replaceAll(RegExp(r'[^\w\s-]'), '');
    final version = packageInfo.version;
    final timestamp = DateFormat('yyyyMMddHHmmss').format(
      clock.now(),
    );

    return '${appName}_${period.fileNamePart}_v$version-$timestamp.csv';
  }

  Future<File> _saveToFile(String content, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(p.join(tempDir.path, fileName));

    await file.writeAsString(content);

    return file;
  }
}
