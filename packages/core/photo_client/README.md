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

final bytes = await pickPhoto();
if (bytes != null) {
  // Store the encoded image.
}

PhotoFileThumbnail(file: file, width: 64, height: 64);
PhotoThumbnail(photoId: photoId, width: 64, height: 64);
```
