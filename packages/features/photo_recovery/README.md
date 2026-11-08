# photo_recovery

Copies photos saved on the device into app storage.

## Features

- Recovers the photos the device photo library can read
- Recovers the photos found in a folder the user selects
- Recovers the photos the user allows in a system dialog
- Commits each photo on its own, so a stopped recovery continues with the photos that remain

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  photo_recovery:
    path: ../../../packages/features/photo_recovery
```

## Usage

```dart
final command = PhotoRecoveryCommand(
  dbClient: dbClient,
  devicePhotos: const DevicePhotos(),
  photoEncoder: const PhotoEncoder(),
  photoStorage: photoStorage,
);

final recovered = await command.recoverFromDevice(
  onProgress: (completed, total) {},
);
```
