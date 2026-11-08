import 'package:flutter/services.dart';

import 'image_compress_exception.dart';
import 'image_format.dart';
import 'size_limit.dart';

/// {@template native_image_compressor.NativeImageCompressor}
/// Compresses image files with the platform's own image codecs.
///
/// Large images are decoded at the reduced size, so they take less time and
/// memory. The orientation is applied to the pixels, and metadata such as the
/// location is not kept.
///
/// Calls can run at the same time. The caller decides how many.
/// {@endtemplate}
class NativeImageCompressor {
  /// {@macro native_image_compressor.NativeImageCompressor}
  const new();

  static const _channel = MethodChannel('com.naipaka.native_image_compressor');

  /// Returns the image at [path] in [format], scaled down to fit [limit].
  ///
  /// [quality] ranges from 0 to 100 and applies to [ImageFormat.jpeg] only.
  ///
  /// Throws [ImageCompressException] if the image cannot be read or written.
  Future<Uint8List> compress(
    String path, {
    SizeLimit? limit,
    ImageFormat format = ImageFormat.jpeg,
    int quality = 90,
  }) async {
    assert(quality >= 0 && quality <= 100, 'quality must be 0 to 100');
    try {
      final size = await _channel.invokeListMethod<int>('size', {
        'path': path,
      });
      final (width, height) = (size![0], size[1]);
      final (targetWidth, targetHeight) =
          limit?.fit(width, height) ?? (width, height);
      final bytes = await _channel.invokeMethod<Uint8List>('compress', {
        'path': path,
        'width': targetWidth,
        'height': targetHeight,
        'format': format.name,
        'quality': quality,
      });
      return bytes!;
    } on PlatformException catch (e) {
      throw ImageCompressException(e.message ?? e.code);
    }
  }
}
