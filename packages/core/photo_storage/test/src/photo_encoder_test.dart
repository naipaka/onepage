import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_image_compressor/native_image_compressor.dart';
import 'package:photo_storage/photo_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.naipaka.native_image_compressor');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final encoded = Uint8List.fromList([0xFF, 0xD8]);
  late Map<Object?, Object?> arguments;
  late List<int> size;
  PlatformException? error;

  setUp(() {
    size = [4032, 3024];
    error = null;
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (error case final error?) {
        throw error;
      }
      if (call.method == 'size') {
        return size;
      }
      arguments = call.arguments as Map<Object?, Object?>;
      return encoded;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
  });

  group('encode', () {
    test('returns a JPEG at the configured quality', () async {
      final result = await const PhotoEncoder().encode('photo.heic');

      expect(result, encoded);
      expect(arguments['path'], 'photo.heic');
      expect(arguments['format'], 'jpeg');
      expect(arguments['quality'], PhotoEncoder.quality);
    });

    test('limits the number of pixels', () async {
      await const PhotoEncoder().encode('photo.heic');

      final width = arguments['width']! as int;
      final height = arguments['height']! as int;
      expect(width * height, lessThanOrEqualTo(PhotoEncoder.maxPixels));
      expect((width, height), (2309, 1732));
    });

    test('keeps small photos at their size', () async {
      size = [1179, 2556];

      await const PhotoEncoder().encode('screenshot.png');

      expect((arguments['width'], arguments['height']), (1179, 2556));
    });

    test('fails when the photo cannot be read', () async {
      error = PlatformException(code: 'code', message: 'Cannot read');

      await expectLater(
        const PhotoEncoder().encode('broken.jpg'),
        throwsA(isA<ImageCompressException>()),
      );
    });
  });
}
