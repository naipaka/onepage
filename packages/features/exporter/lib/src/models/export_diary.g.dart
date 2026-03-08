// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_diary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExportDiary _$ExportDiaryFromJson(Map<String, dynamic> json) => _ExportDiary(
  date: DateTime.parse(json['date'] as String),
  content: json['content'] as String,
);

Map<String, dynamic> _$ExportDiaryToJson(_ExportDiary instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'content': instance.content,
    };
