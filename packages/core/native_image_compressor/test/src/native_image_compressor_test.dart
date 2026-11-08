import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_image_compressor/native_image_compressor.dart';

const _channel = MethodChannel('com.naipaka.native_image_compressor');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NativeImageCompressor', () {
    const compressor = NativeImageCompressor();
    late List<MethodCall> calls;
    PlatformException? error;

    setUp(() {
      calls = [];
      error = null;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_channel, (call) async {
            calls.add(call);
            if (error case final error?) {
              throw error;
            }
            return switch (call.method) {
              'size' => [4032, 3024],
              _ => Uint8List.fromList([1, 2, 3]),
            };
          });
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_channel, null);
    });

    test('compresses to the size that fits the limit', () async {
      final bytes = await compressor.compress(
        'photo.heic',
        limit: const SizeLimit.pixels(4000000),
        quality: 85,
      );

      expect(bytes, [1, 2, 3]);
      expect(calls.first.method, 'size');
      expect(calls.first.arguments, {'path': 'photo.heic'});
      expect(calls.last.method, 'compress');
      expect(calls.last.arguments, {
        'path': 'photo.heic',
        'width': 2309,
        'height': 1732,
        'format': 'jpeg',
        'quality': 85,
      });
    });

    test('keeps the size without a limit', () async {
      await compressor.compress('photo.png', format: ImageFormat.png);

      expect(calls.last.arguments, containsPair('width', 4032));
      expect(calls.last.arguments, containsPair('height', 3024));
      expect(calls.last.arguments, containsPair('format', 'png'));
      expect(calls.last.arguments, containsPair('quality', 90));
    });

    test('throws ImageCompressException when the platform fails', () async {
      error = PlatformException(code: 'code', message: 'Cannot read');

      await expectLater(
        compressor.compress('broken.jpg'),
        throwsA(
          isA<ImageCompressException>().having(
            (e) => e.message,
            'message',
            'Cannot read',
          ),
        ),
      );
    });

    test('uses the error code without a message', () async {
      error = PlatformException(code: 'code');

      await expectLater(
        compressor.compress('broken.jpg'),
        throwsA(
          isA<ImageCompressException>().having(
            (e) => e.toString(),
            'toString',
            'ImageCompressException: code',
          ),
        ),
      );
    });
  });
}
