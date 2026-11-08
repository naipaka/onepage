import 'dart:math';

/// {@template native_image_compressor.SizeLimit}
/// The largest size a compressed image may have.
///
/// Images are scaled down to fit, keeping their aspect ratio, and are never
/// scaled up.
/// {@endtemplate}
sealed class SizeLimit {
  /// {@macro native_image_compressor.SizeLimit}
  const new();

  /// Limits the number of pixels to [maxPixels].
  const factory pixels(int maxPixels) = PixelSizeLimit;

  /// Limits the width to [maxWidth] and the height to [maxHeight].
  const factory box(int maxWidth, int maxHeight) = BoxSizeLimit;

  /// Returns the size of an image of [width] by [height] after it fits this
  /// limit.
  (int, int) fit(int width, int height) {
    final scale = min(1, _scale(width, height));
    return (
      max(1, (width * scale).floor()),
      max(1, (height * scale).floor()),
    );
  }

  double _scale(int width, int height);
}

/// {@template native_image_compressor.PixelSizeLimit}
/// A [SizeLimit] on the number of pixels.
/// {@endtemplate}
final class PixelSizeLimit extends SizeLimit {
  /// {@macro native_image_compressor.PixelSizeLimit}
  const new(this.maxPixels) : assert(maxPixels > 0);

  /// The largest number of pixels.
  final int maxPixels;

  @override
  double _scale(int width, int height) => sqrt(maxPixels / (width * height));
}

/// {@template native_image_compressor.BoxSizeLimit}
/// A [SizeLimit] on the width and the height.
/// {@endtemplate}
final class BoxSizeLimit extends SizeLimit {
  /// {@macro native_image_compressor.BoxSizeLimit}
  const new(this.maxWidth, this.maxHeight)
    : assert(maxWidth > 0 && maxHeight > 0);

  /// The largest width.
  final int maxWidth;

  /// The largest height.
  final int maxHeight;

  @override
  double _scale(int width, int height) {
    return min(maxWidth / width, maxHeight / height);
  }
}
