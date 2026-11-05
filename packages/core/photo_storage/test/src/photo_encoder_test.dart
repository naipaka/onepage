import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_image_compress_common/flutter_image_compress_common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:photo_storage/photo_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('flutter_image_compress');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final encoded = Uint8List.fromList([0xFF, 0xD8]);
  late List<Object?> arguments;

  late Directory directory;

  Future<String> imageOf(int width, int height) async {
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder);
    final image = await recorder.endRecording().toImage(width, height);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    final file = File('${directory.path}/photo.png')
      ..writeAsBytesSync(data!.buffer.asUint8List());
    return file.path;
  }

  setUp(() {
    directory = Directory.systemTemp.createTempSync('photo_encoder_test');
    FlutterImageCompressCommon.registerWith();
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'compressWithFile') {
        arguments = call.arguments as List<Object?>;
        return encoded;
      }
      return null;
    });
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    directory.deleteSync(recursive: true);
  });

  group('encode', () {
    test('fails when the photo cannot be compressed', () async {
      messenger.setMockMethodCallHandler(channel, (call) async => null);
      final path = await imageOf(100, 50);

      await expectLater(const PhotoEncoder().encode(path), throwsA(anything));
    });

    test('returns the compressed bytes at the configured quality', () async {
      final result = await const PhotoEncoder().encode(await imageOf(100, 50));

      expect(result, encoded);
      expect(arguments[3], PhotoEncoder.quality);
    });

    test('keeps small photos at their size', () async {
      await const PhotoEncoder().encode(await imageOf(100, 50));

      expect(arguments.sublist(1, 3), [100, 50]);
    });

    test('limits the long edge of a landscape photo', () async {
      await const PhotoEncoder().encode(await imageOf(4096, 1024));

      expect(arguments.sublist(1, 3), [2048, 512]);
    });

    test('limits the long edge of a portrait photo', () async {
      await const PhotoEncoder().encode(await imageOf(1024, 4096));

      expect(arguments.sublist(1, 3), [512, 2048]);
    });

    test('keeps at least one pixel on the short edge', () async {
      await const PhotoEncoder().encode(await imageOf(8192, 1));

      expect(arguments.sublist(1, 3), [2048, 1]);
    });

    test('decodes large photos at a reduced size', () async {
      await const PhotoEncoder().encode(await imageOf(6400, 100));

      expect(arguments[8], 4);
    });
  });
}
