import 'dart:io';

import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'exporter.dart';
import 'models/models.dart';

/// {@template exporter.MarkdownExporter}
/// Exports diary entries to Markdown format.
/// {@endtemplate}
class MarkdownExporter extends Exporter {
  /// {@macro exporter.MarkdownExporter}
  const MarkdownExporter({
    required this.packageInfo,
  });

  /// Package information for metadata.
  final PackageInfo packageInfo;

  @override
  Future<File> export({
    required List<DiaryEntry> entries,
  }) async {
    final title = _generateTitle(entries);
    final fileName = _generateFileName(title);
    final content = _generateMarkdownContent(entries, title);
    
    return _saveToFile(content, fileName);
  }

  @override
  Future<File> exportMonth({
    required List<DiaryEntry> entries,
    required int year,
    required int month,
  }) async {
    final filteredEntries = entries.where((entry) {
      return entry.date.year == year && entry.date.month == month;
    }).toList();

    final title = DateFormat.yMMMM().format(DateTime(year, month));
    final fileName = _generateFileName(title);
    final content = _generateMarkdownContentForMonth(
      filteredEntries,
      title,
      year,
      month,
    );
    
    return _saveToFile(content, fileName);
  }

  @override
  Future<File> exportDateRange({
    required List<DiaryEntry> entries,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final filteredEntries = entries.where((entry) {
      final entryDate = entry.date;
      return entryDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          entryDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    final title = _generateDateRangeTitle(startDate, endDate);
    final fileName = _generateFileName(title);
    final content = _generateMarkdownContent(filteredEntries, title);
    
    return _saveToFile(content, fileName);
  }

  String _generateMarkdownContent(List<DiaryEntry> entries, String title) {
    final buffer = StringBuffer()
      ..writeln('# $title')
      ..writeln()
      ..writeln(
          'Exported from ${packageInfo.appName} v${packageInfo.version}',
        )
      ..writeln(DateFormat.yMMMd().add_jm().format(clock.now()))
      ..writeln()
      ..writeln('---')
      ..writeln();
    
    final sortedEntries = entries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    
    for (final entry in sortedEntries) {
      buffer
        ..writeln('## ${DateFormat.yMMMEd().format(entry.date)}')
        ..writeln()
        ..writeln(entry.content)
        ..writeln();
    }
    
    return buffer.toString();
  }

  String _generateMarkdownContentForMonth(
    List<DiaryEntry> entries,
    String title,
    int year,
    int month,
  ) {
    final buffer = StringBuffer()
      ..writeln('# $title')
      ..writeln()
      ..writeln(
          'Exported from ${packageInfo.appName} v${packageInfo.version}',
        )
      ..writeln(DateFormat.yMMMd().add_jm().format(clock.now()))
      ..writeln()
      ..writeln('---')
      ..writeln();
    
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final entryMap = <int, DiaryEntry>{};
    
    for (final entry in entries) {
      if (entry.date.year == year && entry.date.month == month) {
        entryMap[entry.date.day] = entry;
      }
    }
    
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      buffer
        ..writeln('## ${DateFormat.yMMMEd().format(date)}')
        ..writeln();
      
      final entry = entryMap[day];
      if (entry != null && entry.content.isNotEmpty) {
        buffer.writeln(entry.content);
      } else {
        buffer.writeln('No entry');
      }
      
      buffer.writeln();
    }
    
    return buffer.toString();
  }

  String _generateTitle(List<DiaryEntry> entries) {
    if (entries.isEmpty) {
      return DateFormat.yMMMM().format(clock.now());
    }

    final dates = entries.map((e) => e.date).toList()..sort();
    final firstDate = dates.first;
    final lastDate = dates.last;

    if (firstDate.year == lastDate.year && firstDate.month == lastDate.month) {
      return DateFormat.yMMMM().format(firstDate);
    } else {
      return '${DateFormat.yMMMM().format(firstDate)} - '
          '${DateFormat.yMMMM().format(lastDate)}';
    }
  }

  String _generateDateRangeTitle(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year && 
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return DateFormat.yMMMEd().format(startDate);
    }
    
    if (startDate.year == endDate.year && startDate.month == endDate.month) {
      return DateFormat.yMMMM().format(startDate);
    }
    
    return '${DateFormat.yMMMd().format(startDate)} - '
           '${DateFormat.yMMMd().format(endDate)}';
  }

  String _generateFileName(String title) {
    final appName = packageInfo.appName.replaceAll(RegExp(r'[^\w\s-]'), '');
    final version = packageInfo.version;
    final timestamp = DateFormat('yyyyMMddHHmmss').format(
      clock.now(),
    );

    final sanitizedTitle = title
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
    return '${appName}_${sanitizedTitle}_v$version-$timestamp.md';
  }

  Future<File> _saveToFile(String content, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File(p.join(tempDir.path, fileName));

    await file.writeAsString(content);

    return file;
  }
}
