import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:photo_client/photo_client.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakeImagePicker extends ImagePickerPlatform
    with MockPlatformInterfaceMixin {
  new(this.file);

  final XFile? file;
  ImagePickerOptions? options;
  ImageSource? source;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    this.source = source;
    this.options = options;
    return file;
  }
}

void main() {
  group('pickPhoto', () {
    test('returns the bytes of the picked photo', () async {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final picker = _FakeImagePicker(XFile.fromData(bytes));
      ImagePickerPlatform.instance = picker;

      expect(await pickPhoto(), bytes);
      expect(picker.source, ImageSource.gallery);
      expect(picker.options?.requestFullMetadata, isFalse);
    });

    test('returns null when the user cancels', () async {
      ImagePickerPlatform.instance = _FakeImagePicker(null);

      expect(await pickPhoto(), isNull);
    });
  });
}
