import 'dart:io';

import 'exporter.dart';
import 'models/models.dart';

/// {@template exporter.CsvExporter}
/// Exports diary entries to CSV format.
/// {@endtemplate}
class CsvExporter extends Exporter {
  /// {@macro exporter.CsvExporter}
  const CsvExporter();

  @override
  Future<File> export({
    required List<DiaryEntry> entries,
  }) async {
    throw UnimplementedError('CSV export not yet implemented');
  }

  @override
  Future<File> exportMonth({
    required List<DiaryEntry> entries,
    required int year,
    required int month,
  }) async {
    throw UnimplementedError('CSV export not yet implemented');
  }

  @override
  Future<File> exportDateRange({
    required List<DiaryEntry> entries,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    throw UnimplementedError('CSV export not yet implemented');
  }
}
