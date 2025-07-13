import 'dart:io';

import 'exporter.dart';
import 'models/models.dart';

/// {@template exporter.MarkdownExporter}
/// Exports diary entries to Markdown format.
/// {@endtemplate}
class MarkdownExporter extends Exporter {
  /// {@macro exporter.MarkdownExporter}
  const MarkdownExporter();

  @override
  Future<File> export({
    required List<DiaryEntry> entries,
  }) async {
    throw UnimplementedError('Markdown export not yet implemented');
  }

  @override
  Future<File> exportMonth({
    required List<DiaryEntry> entries,
    required int year,
    required int month,
  }) async {
    throw UnimplementedError('Markdown export not yet implemented');
  }

  @override
  Future<File> exportDateRange({
    required List<DiaryEntry> entries,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    throw UnimplementedError('Markdown export not yet implemented');
  }
}
