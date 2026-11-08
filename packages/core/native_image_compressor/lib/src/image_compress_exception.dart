/// {@template native_image_compressor.ImageCompressException}
/// Thrown when an image cannot be read or written.
/// {@endtemplate}
class ImageCompressException implements Exception {
  /// {@macro native_image_compressor.ImageCompressException}
  const new(this.message);

  /// Why the image could not be compressed.
  final String message;

  @override
  String toString() => 'ImageCompressException: $message';
}
