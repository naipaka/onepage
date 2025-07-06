import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_setting.freezed.dart';
part 'notification_setting.g.dart';

/// {@template notification_setting}
/// Represents a notification time setting for diary reminders.
/// Each setting has a unique ID, hour (0-23), and enabled status.
/// {@endtemplate}
@freezed
abstract class NotificationSetting with _$NotificationSetting {
  /// {@macro notification_setting}
  const factory NotificationSetting({
    /// Unique identifier for this notification setting.
    required int id,

    /// Hour of the day (0-23) when notification should be sent.
    required int hour,

    /// Whether this notification is currently enabled.
    required bool isEnabled,
  }) = _NotificationSetting;

  /// Create a NotificationSetting from JSON.
  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingFromJson(json);
}
