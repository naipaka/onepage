# native_image_compressor

Compresses image files with the platform's own image codecs.

## Features

- Reads large images at a reduced size, so they take less time and memory: ImageIO on iOS, `ImageDecoder` on Android 9 and later, and `BitmapFactory` with `inSampleSize` on Android 7 and 8
- Scales images down to fit a limit on the number of pixels or on the width and the height, and never scales them up
- Writes JPEG or PNG
- Applies the orientation to the pixels and keeps no metadata
- Runs calls at the same time on background threads

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  native_image_compressor:
    path: ../../../packages/core/native_image_compressor
```

## Usage

```dart
const compressor = NativeImageCompressor();

final bytes = await compressor.compress(
  path,
  limit: const SizeLimit.pixels(4000000),
  format: ImageFormat.jpeg,
  quality: 85,
);
```

## Testing

The Android sample size and orientation logic have JVM unit tests:

```bash
fvm dart run melos run test:android --no-select
```
