import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'models/models.dart';

/// {@template notification_client}
/// Client for managing local notifications for diary reminders.
/// Handles notification permissions, scheduling, and cancellation.
/// {@endtemplate}
class NotificationClient {
  /// {@macro notification_client}
  NotificationClient._({
    required FlutterLocalNotificationsPlugin notificationsPlugin,
    required String channelName,
    required String channelDescription,
  }) : _notifications = notificationsPlugin,
       _channelName = channelName,
       _channelDescription = channelDescription;

  /// Create a NotificationClient with default plugin
  factory NotificationClient.create({
    required String channelName,
    required String channelDescription,
  }) {
    return NotificationClient._(
      notificationsPlugin: FlutterLocalNotificationsPlugin(),
      channelName: channelName,
      channelDescription: channelDescription,
    );
  }

  /// Create a NotificationClient for testing with custom plugin
  @visibleForTesting
  NotificationClient.forTesting({
    required FlutterLocalNotificationsPlugin notificationsPlugin,
    required String channelName,
    required String channelDescription,
  }) : _notifications = notificationsPlugin,
       _channelName = channelName,
       _channelDescription = channelDescription;

  final FlutterLocalNotificationsPlugin _notifications;
  final String _channelName;
  final String _channelDescription;

  /// Initialize the notification system.
  /// Must be called before using any other methods.
  Future<void> initialize() async {
    // Initialize timezone data
    tz.initializeTimeZones();
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@drawable/ic_notification',
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
  }

  /// Request notification permissions from the user.
  /// Returns true if permissions were granted.
  Future<bool> requestPermissions() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final iosImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation != null) {
      final granted = await androidImplementation
          .requestNotificationsPermission();

      return granted ?? false;
    }

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      return granted ?? false;
    }

    return false;
  }

  /// Schedule notifications based on the provided settings.
  ///
  /// [settings] - List of notification time settings
  /// [title] - Title to use for notifications
  /// [message] - Message to use for notifications
  Future<void> scheduleNotifications(
    List<NotificationSetting> settings, {
    required String title,
    required String message,
  }) async {
    // Cancel existing notifications first
    await cancelAllNotifications();

    for (final setting in settings) {
      if (!setting.isEnabled) {
        continue;
      }

      await _scheduleRepeatingNotification(
        id: setting.id,
        title: title,
        body: message,
        hour: setting.hour,
        channelName: _channelName,
        channelDescription: _channelDescription,
      );
    }
  }

  /// Cancel all scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Cancel a specific notification by ID.
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> _scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required String channelName,
    required String channelDescription,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'diary_reminder',
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexact,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
