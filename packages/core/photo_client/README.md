# Photo Client

Lets the user pick a photo with the system picker, and displays photos.

## Features

- Picking a photo without photo library permission
- Thumbnails with a full-screen viewer
- Viewing photos from the device photo library by photo ID

## Getting started

To use this package, add `photo_client` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  photo_client:
    path: ../photo_client/
```

## Usage

```dart
import 'package:photo_client/photo_client.dart';

final photo = await pickPhoto();
if (photo != null) {
  // Store the photo, then delete the temporary copy.
  await photo.delete();
}

PhotoFileThumbnail(file: file, width: 64, height: 64);
PhotoThumbnail(photoId: photoId, width: 64, height: 64);
```
