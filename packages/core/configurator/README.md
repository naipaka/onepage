# configurator

A Flutter package for Firebase Remote Config wrapper functionality.

## Features

- Wrapper for Firebase Remote Config with simplified API
- Type-safe parameter retrieval (String, int, double, bool, JSON)
- Real-time configuration updates with Stream support
- Automatic internal Firebase Remote Config initialization
- Configuration settings management
- Default values support

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  configurator:
    path: packages/core/configurator
```

## Usage

### Basic Setup

```dart
import 'package:configurator/configurator.dart';

final configurator = Configurator();

// Configure settings
await configurator.configure(
  fetchTimeout: Duration(seconds: 10),
  minimumFetchInterval: Duration(hours: 1),
);

// Set default values
await configurator.setDefaults({
  'feature_enabled': false,
  'api_url': 'https://api.example.com',
});

// Fetch and activate remote config
await configurator.fetchAndActivate();
```

### Retrieving Configuration Values

```dart
// Get simple values
final featureEnabled = configurator.getBool('feature_enabled');
final apiUrl = configurator.getString('api_url');
final maxRetries = configurator.getInt('max_retries');

// Get JSON data
final jsonConfig = configurator.getJson('complex_config');
final listConfig = configurator.getListJson('items_list');

// Get typed data with custom parser
final customData = configurator.getData<MyModel>(
  key: 'my_model_config',
  fromJson: MyModel.fromJson,
);
```

### Real-time Updates

```dart
// Get config with real-time updates
final config = configurator.getStringConfig(
  'feature_flag',
  onConfigUpdated: (newValue) {
    print('Config updated: $newValue');
  },
);

// Access current value
print('Current value: ${config.value}');

// Dispose when no longer needed
await config.dispose();
```