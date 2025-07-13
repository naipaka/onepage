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
    required List<DiaryEntry> entries,
  });

  /// Exports diary entries for a specific month.
  Future<File> exportMonth({
    required List<DiaryEntry> entries,
    required int year,
    required int month,
  });

  /// Exports diary entries for a specific date range.
  Future<File> exportDateRange({
    required List<DiaryEntry> entries,
    required DateTime startDate,
    required DateTime endDate,
  });
}
