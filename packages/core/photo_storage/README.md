# photo_storage

Stores diary photo files in a directory owned by the app.

## Features

- Compresses photos to JPEG
- Saves photos under generated file names
- Publishes a photo under its final name only after it is fully written

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  photo_storage:
    path: ../../../packages/core/photo_storage
```

## Usage

```dart
final storage = await PhotoStorage.create();

final encoded = await const PhotoEncoder().encode(path);
final fileName = await storage.save(encoded);
final file = storage.file(fileName);

await storage.delete(fileName);
```
