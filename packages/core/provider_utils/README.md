# Provider Utils

A Flutter package for common utilities for the riverpod packages.

## Features

- Provides overridden providers for common use cases.
- Provider Logger.

## Getting started

To use this package, add `provider_utils` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  provider_utils:
    path: ../provider_utils/
```

## Usage

Here is an example of how to use the `ProviderLogger` widget.

```dart
void main() {
  const providerLogPrint = String.fromEnvironment('providerLogPrint');
  final outputLogTypes = ProviderEvent.getEventsFromNames(providerLogPrint);
  final providerLogger = ProviderLogger(
    outputLogTypes: outputLogTypes,
    logger: logger,
  );

  runApp(
    ProviderScope(
      observers: [providerLogger],
      child: const App(),
    ),
  );
}
```
