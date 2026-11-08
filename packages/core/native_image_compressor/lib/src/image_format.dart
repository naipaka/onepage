/// A format that `NativeImageCompressor` can write.
enum ImageFormat {
  /// JPEG, which uses the quality.
  jpeg,

  /// PNG, which ignores the quality.
  png,
}
