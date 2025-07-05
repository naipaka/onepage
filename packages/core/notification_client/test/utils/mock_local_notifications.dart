import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const channel = MethodChannel('dexterous.com/flutter/local_notifications');

final methodCallLog = <MethodCall>[];

void setupMockLocalNotification() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
        methodCallLog.add(methodCall);
        switch (methodCall.method) {
          case 'initialize':
            return true;
          case 'pendingNotificationRequests':
            return <Map<String, Object?>>[];
          case 'getActiveNotifications':
            return <Map<String, Object?>>[];
          case 'getNotificationAppLaunchDetails':
            return <String, Object?>{
              'notificationLaunchedApp': false,
              'notificationResponse': null,
            };
          case 'requestPermissions':
            return true;
          case 'areNotificationsEnabled':
            return true;
          case 'zonedSchedule':
            return null;
          case 'cancel':
            return null;
          case 'cancelAll':
            return null;
          case 'requestExactAlarmsPermission':
            return true;
          case 'requestNotificationsPermission':
            return true;
          default:
            return null;
        }
      });
}

void tearDownMockLocalNotification() {
  debugDefaultTargetPlatformOverride = null;
  methodCallLog.clear();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, null);
}
