import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'diary_entry.freezed.dart';
part 'diary_entry.g.dart';

/// {@template exporter.DiaryEntry}
/// Data model for a diary entry to be exported.
/// {@endtemplate}
@freezed
abstract class DiaryEntry with _$DiaryEntry {
  /// {@macro exporter.DiaryEntry}
  const factory DiaryEntry({
    /// The date of the diary entry.
    required DateTime date,

    /// The content of the diary entry.
    required String content,
  }) = _DiaryEntry;

  /// {@macro exporter.DiaryEntry}
  ///
  /// Returns a new [DiaryEntry] from a JSON object.
  factory DiaryEntry.fromJson(Map<String, Object?> json) =>
      _$DiaryEntryFromJson(json);
}
