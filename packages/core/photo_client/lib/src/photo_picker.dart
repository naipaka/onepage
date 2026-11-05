import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// Lets the user pick a photo with the system picker.
///
/// Returns the encoded image, or null if the user cancels.
Future<Uint8List?> pickPhoto() async {
  final platform = ImagePickerPlatform.instance;
  if (platform is ImagePickerAndroid) {
    platform.useAndroidPhotoPicker = true;
  }

  final file = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    requestFullMetadata: false,
  );
  return file?.readAsBytes();
}
