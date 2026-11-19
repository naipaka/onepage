# Provider Utils

A Flutter package for common utilities for the riverpod packages.

## Features

- Provides overridden providers for common use cases.
- Provider Logger.
- `ProviderFailureReporter`, which passes the errors that providers fail with to a callback, such as an error tracker.
- `noRetry`, a retry setting that retries no failed provider.

## Getting started

To use this package, add `provider_utils` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  provider_utils:
    path: ../provider_utils/
```

## Usage

Here is an example of how to use `ProviderLogger`, `ProviderFailureReporter`, and `noRetry`.

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
      observers: [
        providerLogger,
        ProviderFailureReporter(
          onFailure: (error, stackTrace) =>
              unawaited(tracker.recordError(error, stackTrace)),
        ),
      ],
      retry: noRetry,
      child: const App(),
    ),
  );
}
```
