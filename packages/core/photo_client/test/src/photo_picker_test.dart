import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker_android/image_picker_android.dart';
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

class _FakeAndroidImagePicker extends ImagePickerAndroid {
  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async => null;
}

void main() {
  group('pickPhoto', () {
    test('returns the picked photo file', () async {
      final picker = _FakeImagePicker(XFile('picked.jpg'));
      ImagePickerPlatform.instance = picker;

      final file = await pickPhoto();

      expect(file?.path, 'picked.jpg');
      expect(picker.source, ImageSource.gallery);
      expect(picker.options?.requestFullMetadata, isFalse);
    });

    test('uses the Android Photo Picker on Android', () async {
      final picker = _FakeAndroidImagePicker();
      ImagePickerPlatform.instance = picker;

      await pickPhoto();

      expect(picker.useAndroidPhotoPicker, isTrue);
    });

    test('returns null when the user cancels', () async {
      ImagePickerPlatform.instance = _FakeImagePicker(null);

      expect(await pickPhoto(), isNull);
    });
  });
}
