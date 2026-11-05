import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// {@template photo_storage.PhotoEncoder}
/// Compresses photos into the JPEG format stored by the app.
/// {@endtemplate}
class PhotoEncoder {
  /// {@macro photo_storage.PhotoEncoder}
  const new();

  /// Maximum length of the long edge of an encoded photo.
  static const maxLongEdge = 2048;

  /// JPEG quality of an encoded photo.
  static const quality = 85;

  /// Smallest long edge a photo may be decoded at before it is resized.
  static const _minDecodedLongEdge = 1600;

  /// Returns [bytes] as a compressed JPEG.
  ///
  /// Photos are decoded at a reduced size when possible, because decoding a
  /// large photo at full size runs out of memory on Android 7.
  Future<Uint8List> encode(Uint8List bytes) async {
    final (width, height) = await _readSize(bytes);
    final longEdge = max(width, height);
    final scale = min(1, maxLongEdge / longEdge);

    var sampleSize = 1;
    while (longEdge / (sampleSize * 2) >= _minDecodedLongEdge) {
      sampleSize *= 2;
    }

    return FlutterImageCompress.compressWithList(
      bytes,
      minWidth: max(1, (width * scale).round()),
      minHeight: max(1, (height * scale).round()),
      quality: quality,
      inSampleSize: sampleSize,
    );
  }

  Future<(int, int)> _readSize(Uint8List bytes) async {
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    final descriptor = await ui.ImageDescriptor.encoded(buffer);
    final size = (descriptor.width, descriptor.height);
    descriptor.dispose();
    buffer.dispose();
    return size;
  }
}
