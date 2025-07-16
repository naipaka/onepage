# tracker

A Flutter package for Firebase Analytics wrapper functionality.

## Features

- Wrapper for Firebase Analytics and Crashlytics with simplified API
- Event tracking and error logging
- User identification and properties management
- Screen view tracking
- Navigator observers for automatic screen tracking
- Automatic internal Firebase initialization
- Support for additional trackable implementations

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  tracker:
    path: packages/core/tracker
```

## Usage

### Basic Setup

```dart
import 'package:tracker/tracker.dart';

final tracker = Tracker();

// Set up error handling
FlutterError.onError = tracker.onFlutterError;
PlatformDispatcher.instance.onError = tracker.onPlatformError;

// Set up isolate error handling
Isolate.current.addErrorListener(
  tracker.isolateErrorListener()
);
```

### User Management

```dart
// Set user ID
await tracker.setUserId('user_123');

// Set user properties
await tracker.setUserProperties({
  'plan': 'premium',
  'sign_up_date': '2023-01-01',
});

// Clear user ID
await tracker.clearUserId();
```

### Event Tracking

```dart
// Log custom events
await tracker.logEvent('button_pressed', parameters: {
  'button_name': 'checkout',
  'screen': 'product_detail',
});

// Track screen views
await tracker.trackScreenView('home_screen');
```

### Navigation Tracking

```dart
// Add to your MaterialApp
MaterialApp(
  navigatorObservers: tracker.navigatorObservers(),
  // ... other properties
)

// Or use individual observer
MaterialApp(
  navigatorObservers: [
    tracker.navigatorObserver(
      nameExtractor: (settings) => settings.name,
    ),
  ],
  // ... other properties
)
```

### Error Tracking

```dart
// Record custom errors
try {
  // Some operation that might fail
} catch (error, stackTrace) {
  await tracker.recordError(error, stackTrace, fatal: false);
}
```