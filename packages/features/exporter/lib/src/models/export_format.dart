import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_format.freezed.dart';

/// {@template exporter.ExportFormat}
/// Represents the available export formats for diary entries.
/// {@endtemplate}
@freezed
abstract class ExportFormat with _$ExportFormat {
  /// {@macro exporter.ExportFormat}
  const factory ExportFormat.pdf() = _Pdf;

  /// {@macro exporter.ExportFormat}
  const factory ExportFormat.csv() = _Csv;

  /// {@macro exporter.ExportFormat}
  const factory ExportFormat.markdown() = _Markdown;

  const ExportFormat._();

  /// Gets the display name for this export format.
  String get displayName => when(
        pdf: () => 'PDF',
        csv: () => 'CSV',
        markdown: () => 'Markdown',
      );

  /// Gets the file extension for this export format.
  String get fileExtension => when(
        pdf: () => '.pdf',
        csv: () => '.csv',
        markdown: () => '.md',
      );
}
