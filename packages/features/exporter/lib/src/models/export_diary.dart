import 'package:flutter/foundation.dart';

/// {@template exporter.ExportDiary}
/// A simplified diary entry model for exporting purposes.
///
/// This model contains only the essential fields (date and content) needed
/// for exporting diary entries to various formats (PDF, CSV, Markdown).
/// {@endtemplate}
@immutable
class ExportDiary {
  /// {@macro exporter.ExportDiary}
  const new({
    required this.date,
    required this.content,
  });

  /// The date of the diary entry.
  final DateTime date;

  /// The content of the diary entry.
  final String content;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ExportDiary &&
        other.date == date &&
        other.content == content;
  }

  @override
  int get hashCode => Object.hash(date, content);

  @override
  String toString() => 'ExportDiary(date: $date, content: $content)';
}
