// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSetting _$NotificationSettingFromJson(Map<String, dynamic> json) =>
    _NotificationSetting(
      id: (json['id'] as num).toInt(),
      hour: (json['hour'] as num).toInt(),
      isEnabled: json['isEnabled'] as bool,
    );

Map<String, dynamic> _$NotificationSettingToJson(
  _NotificationSetting instance,
) => <String, dynamic>{
  'id': instance.id,
  'hour': instance.hour,
  'isEnabled': instance.isEnabled,
};
