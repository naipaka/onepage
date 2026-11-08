# device_photos

Reads photos saved on the device by the photo IDs stored in the database.

## Features

- Requests access to the photo library
- Tells how the app can get access to more photos
- Reads the original file of a stored photo ID
- On Android 11 and later, asks the user to allow access to stored photo IDs in a system dialog
- On Android 10, lets the user select a folder and matches its files to stored photo IDs

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
  case DevicePhotoAccessOption.selectFolder:
    final folder = await devicePhotos.pickFolder();
    final documents = await devicePhotos.findInFolder(
      folder: folder!,
      ids: [photoId],
    );
    final copy = await devicePhotos.copyDocument(documents[photoId]!);
  case DevicePhotoAccessOption.openSettings || DevicePhotoAccessOption.none:
    break;
}
```

## Testing

The folder scan has JVM unit tests:

```bash
fvm dart run melos run test:android --no-select
```
