# Photo Selector

This package provides photo selection functionality from device photo library with permission handling and album browsing.

## Features

- Cross-platform photo selection (Android/iOS)
- Photo library permission handling
- Album browsing and selection
- Photo grid display with pagination
- Single photo selection with visual feedback
- Integration with photo_manager and app_settings
- Internationalization support via parameter injection

## Getting started

To use this package, add `photo_selector` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  photo_selector:
    path: ../photo_selector/
```

## Usage

Here is an example of how to use this package.

```dart
import 'package:photo_selector/photo_selector.dart';

// Show photo selector dialog
final photoId = await showPhotoSelector(
  context,
  okLabel: 'OK',
  noPhotosLabel: 'No photos available',
  permissionDeniedTitle: 'Photo library access required',
  permissionDeniedMessage: 'Please allow access to your photo library in settings',
  openSettingsLabel: 'Open Settings',
);

if (photoId != null) {
  // Selected photo ID (iOS: PHAsset localIdentifier, Android: MediaStore ID)
  print('Selected photo: $photoId');
}
```

## Photo Selection

The `showPhotoSelector` function displays a full-screen dialog for photo selection:

```dart
final photoId = await showPhotoSelector(
  context,
  okLabel: t.home.datePickerConfirm,
  noPhotosLabel: t.home.photoSelector.noPhotos,
  permissionDeniedTitle: t.home.photoSelector.permission.deniedTitle,
  permissionDeniedMessage: t.home.photoSelector.permission.deniedMessage,
  openSettingsLabel: t.home.photoSelector.permission.openSettings,
);
```

The function returns:
- `String?` - The selected photo ID, or `null` if cancelled
- iOS: PHAsset localIdentifier
- Android: MediaStore ID

## Permission Handling

The package automatically handles photo library permissions:

1. Requests permission when first accessing photos
2. Shows a permission error screen if denied
3. Provides a button to open app settings for permission management

## Features

- **Album Selection**: Browse and switch between photo albums via AppBar dropdown
- **Photo Grid**: 4-column grid layout with thumbnail display
- **Pagination**: Progressive loading of photos (80 per page) for performance
- **Visual Feedback**: Selected photo is highlighted with a border and checkmark
- **In-Page Toggle**: Switch between photo grid and album list without navigation

## Internationalization

The package does not depend on i18n packages. All user-facing text is passed as parameters:

- `okLabel` - Confirmation button text
- `noPhotosLabel` - Empty state message
- `permissionDeniedTitle` - Permission error title
- `permissionDeniedMessage` - Permission error description
- `openSettingsLabel` - Settings button text

This allows the calling app to provide localized strings.
