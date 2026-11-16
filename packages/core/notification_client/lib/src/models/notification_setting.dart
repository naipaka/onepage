import 'package:flutter/foundation.dart';

/// {@template notification_setting}
/// Represents a notification time setting for diary reminders.
/// Each setting has a unique ID, hour (0-23), and enabled status.
/// {@endtemplate}
@immutable
class NotificationSetting {
  /// {@macro notification_setting}
  const new({
    required this.id,
    required this.hour,
    required this.isEnabled,
  });

  /// Create a NotificationSetting from JSON.
  factory fromJson(Map<String, dynamic> json) => NotificationSetting(
    id: (json['id'] as num).toInt(),
    hour: (json['hour'] as num).toInt(),
    isEnabled: json['isEnabled'] as bool,
  );

  /// Unique identifier for this notification setting.
  final int id;

  /// Hour of the day (0-23) when notification should be sent.
  final int hour;

  /// Whether this notification is currently enabled.
  final bool isEnabled;

  /// Converts this setting to JSON.
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'hour': hour,
    'isEnabled': isEnabled,
  };

  /// Creates a copy of this [NotificationSetting] with the given fields
  /// replaced with new values.
  NotificationSetting copyWith({
    int? id,
    int? hour,
    bool? isEnabled,
  }) {
    return NotificationSetting(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is NotificationSetting &&
        other.id == id &&
        other.hour == hour &&
        other.isEnabled == isEnabled;
  }

  @override
  int get hashCode => Object.hash(id, hour, isEnabled);

  @override
  String toString() =>
      'NotificationSetting(id: $id, hour: $hour, isEnabled: $isEnabled)';
}
