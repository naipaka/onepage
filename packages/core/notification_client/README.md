# Notification Client

This package provides local notification management for diary reminder notifications.

## Features

- Cross-platform notification scheduling (Android/iOS)
- Notification permission handling
- Daily recurring notifications with timezone support
- Notification cancellation and management
- Integration with flutter_local_notifications
- Freezed data models for type safety

## Getting started

To use this package, add `notification_client` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  notification_client:
    path: ../notification_client/
```

## Usage

Here is an example of how to use this package.

```dart
import 'package:notification_client/notification_client.dart';

void main() async {
  // Create and initialize the notification client
  final notificationClient = await NotificationClientImpl.create();
  
  // Request permissions
  final status = await notificationClient.requestPermissions();
  
  if (status == NotificationPermissionStatus.granted) {
    // Create notification settings
    final settings = [
      NotificationSetting(id: 1, hour: 8, isEnabled: true),
      NotificationSetting(id: 2, hour: 20, isEnabled: true),
    ];
    
    // Schedule notifications
    await notificationClient.scheduleNotifications(
      settings,
      titles: ['Diary Time!', 'Write your thoughts'],
      messages: ['Take a moment to reflect on your day.', 'What happened today?'],
      skipIfDiaryExists: false,
    );
  }
}
```

## Notification Settings

The package uses `NotificationSetting` model created with Freezed:

```dart
final setting = NotificationSetting(
  id: 1,           // Unique identifier
  hour: 8,         // Hour of day (0-23)
  isEnabled: true, // Whether notification is active
);

// Settings are immutable and support copyWith
final updatedSetting = setting.copyWith(isEnabled: false);
```

## Permission Handling

The package handles notification permissions for both Android and iOS:

```dart
// Check current permission status
final status = await notificationClient.getPermissionStatus();

// Request permissions if needed
if (status != NotificationPermissionStatus.granted) {
  final newStatus = await notificationClient.requestPermissions();
}
```

## Cancelling Notifications

```dart
// Cancel all notifications
await notificationClient.cancelAllNotifications();

// Cancel specific notification
await notificationClient.cancelNotification(1);
```