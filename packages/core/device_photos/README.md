# device_photos

Reads photos saved on the device by the photo IDs stored in the database.

## Features

- On iOS and Android 12 and earlier, requests access to the photo library and reads the original file of a stored photo ID
- On Android 13 and later, asks the user to allow access to stored photo IDs in a system dialog
- Tells how the app can get access to more photos

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

switch (await devicePhotos.accessOption([photoId])) {
  case DevicePhotoAccessOption.requestPhotos:
    final documents = await devicePhotos.requestPhotos([photoId]);
    final copy = await devicePhotos.copyDocument(documents![photoId]!);
  case DevicePhotoAccessOption.openSettings || DevicePhotoAccessOption.none:
    break;
}
```
