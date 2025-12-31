import 'dart:io';

import 'models/models.dart';

/// {@template exporter.Exporter}
/// Abstract base class for exporting diary entries.
/// {@endtemplate}
abstract class Exporter {
  /// {@macro exporter.Exporter}
  const Exporter();

  /// Exports diary entries to a file.
  Future<File> export({
    required List<ExportDiary> entries,
  });

  /// Exports diary entries for a specific month.
  Future<File> exportMonth({
    required List<ExportDiary> entries,
    required int year,
    required int month,
  });

  /// Exports diary entries for a specific date range.
  Future<File> exportDateRange({
    required List<ExportDiary> entries,
    required DateTime startDate,
    required DateTime endDate,
  });
}
