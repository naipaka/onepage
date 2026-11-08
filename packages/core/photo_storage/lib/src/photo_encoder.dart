import 'dart:typed_data';

import 'package:native_image_compressor/native_image_compressor.dart';

/// {@template photo_storage.PhotoEncoder}
/// Compresses photos into the JPEG format stored by the app.
/// {@endtemplate}
class PhotoEncoder {
  /// {@macro photo_storage.PhotoEncoder}
  const new();

  /// Maximum number of pixels in an encoded photo.
  ///
  /// Four megapixels is about the size of a phone screenshot, so most
  /// screenshots in a diary keep their full size and stay readable, while
  /// camera photos shrink to keep storage and backups small.
  static const maxPixels = 4000000;

  /// JPEG quality of an encoded photo.
  static const quality = 85;

  static const _compressor = NativeImageCompressor();

  /// Returns the photo at [path] as a compressed JPEG.
  ///
  /// Throws [ImageCompressException] if the photo cannot be read.
  Future<Uint8List> encode(String path) {
    return _compressor.compress(
      path,
      limit: const SizeLimit.pixels(maxPixels),
      quality: quality,
    );
  }
}
