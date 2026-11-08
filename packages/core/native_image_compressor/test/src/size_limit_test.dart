import 'package:flutter_test/flutter_test.dart';
import 'package:native_image_compressor/native_image_compressor.dart';

void main() {
  group('SizeLimit.pixels', () {
    const limit = SizeLimit.pixels(4000000);

    test('scales a camera photo down to the pixel count', () {
      final (width, height) = limit.fit(4032, 3024);

      expect((width, height), (2309, 1732));
      expect(width * height, lessThanOrEqualTo(4000000));
    });

    test('keeps the aspect ratio of a tall screenshot', () {
      final (width, height) = limit.fit(1179, 6000);

      expect((width, height), (886, 4511));
      expect(width * height, lessThanOrEqualTo(4000000));
    });

    test('keeps an image that already fits', () {
      expect(limit.fit(1179, 2556), (1179, 2556));
    });
  });

  group('SizeLimit.box', () {
    const limit = SizeLimit.box(2048, 2048);

    test('scales the longer side down to the box', () {
      expect(limit.fit(4032, 3024), (2048, 1536));
      expect(limit.fit(3024, 4032), (1536, 2048));
    });

    test('keeps an image that already fits', () {
      expect(limit.fit(1000, 800), (1000, 800));
    });
  });

  test('never makes a side smaller than one pixel', () {
    expect(const SizeLimit.box(10, 10).fit(10000, 1), (10, 1));
  });
}
