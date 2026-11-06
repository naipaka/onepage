# device_photos

Reads photos saved on the device by the photo IDs stored in the database.

## Features

- Requests access to the photo library
- Reads the original file of a stored photo ID
- On Android 10 and later, lets the user select a folder and matches its files to stored photo IDs

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  device_photos:
    path: ../../../packages/core/device_photos
```

## Usage

```dart
const devicePhotos = DevicePhotos();

final access = await devicePhotos.requestAccess();
final file = await devicePhotos.read(photoId);

if (await devicePhotos.supportsFolder) {
  final folder = await devicePhotos.pickFolder();
  final documents = await devicePhotos.findInFolder(
    folder: folder!,
    ids: [photoId],
  );
  final copy = await devicePhotos.copyDocument(documents[photoId]!);
}
```

## Testing

The folder scan has JVM unit tests:

```bash
fvm dart run melos run test:android --no-select
```
