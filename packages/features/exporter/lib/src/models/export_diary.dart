import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'export_diary.freezed.dart';
part 'export_diary.g.dart';

/// {@template exporter.ExportDiary}
/// A simplified diary entry model for exporting purposes.
///
/// This model contains only the essential fields (date and content) needed
/// for exporting diary entries to various formats (PDF, CSV, Markdown).
/// {@endtemplate}
@freezed
abstract class ExportDiary with _$ExportDiary {
  /// {@macro exporter.ExportDiary}
  const factory ExportDiary({
    /// The date of the diary entry.
    required DateTime date,

    /// The content of the diary entry.
    required String content,
  }) = _ExportDiary;

  /// Creates an [ExportDiary] instance from a JSON object.
  factory ExportDiary.fromJson(Map<String, Object?> json) =>
      _$ExportDiaryFromJson(json);
}
