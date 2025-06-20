# Haptics

This package provides haptic feedback functionality with preference-based control for the application.

## Features

- Semantic haptic feedback methods for different interaction types
- Preference-based control for text input and other interactions
- Optimized feedback intensity for each interaction type
- Integration with SharedPreferences through prefs_client

## Getting started

To use this package, add `haptics` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  haptics:
    path: ../haptics/
```

## Usage

Here is an example of how to use this package.

```dart
import 'package:haptics/haptics.dart';
import 'package:prefs_client/prefs_client.dart';

void main() async {
  // Initialize dependencies
  final prefsClient = await PrefsClient.initialize();
  final haptics = Haptics(prefsClient: prefsClient);
  
  // Trigger haptic feedback for different interaction types
  await haptics.textInputFeedback();    // Light impact for text input
  await haptics.buttonTapFeedback();    // Medium impact for button taps
  await haptics.toggleFeedback();       // Selection click for toggles
  await haptics.navigationFeedback();   // Light impact for navigation
}
```

The haptic feedback will only be triggered if the corresponding preference is enabled in the user's settings.