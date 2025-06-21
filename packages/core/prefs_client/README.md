# Prefs Client

This package provides a type-safe wrapper around SharedPreferences for the application.

## Features

- Type-safe preference access with enum-based keys
- Default value handling for preferences
- Simple SharedPreferences wrapper with error handling
- Easy integration with dependency injection

## Getting started

To use this package, add `prefs_client` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  prefs_client:
    path: ../prefs_client/
```

## Usage

Here is an example of how to use this package.

```dart
import 'package:prefs_client/prefs_client.dart';

void main() async {
  // Initialize the prefs client
  final prefsClient = await PrefsClient.initialize();
  
  // Read haptic feedback settings (defaults to true)
  final textInputHaptic = prefsClient.textInputHapticEnabled;
  final otherHaptic = prefsClient.otherHapticEnabled;
  
  // Update haptic feedback settings
  await prefsClient.setTextInputHapticEnabled(enabled: false);
  await prefsClient.setOtherHapticEnabled(enabled: true);
}
```