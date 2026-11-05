import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

/// Lets the user pick a photo with the system picker.
///
/// Returns a temporary copy of the photo, which the caller must delete, or
/// null if the user cancels.
Future<File?> pickPhoto() async {
  final platform = ImagePickerPlatform.instance;
  if (platform is ImagePickerAndroid) {
    platform.useAndroidPhotoPicker = true;
  }

  final file = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    requestFullMetadata: false,
  );
  return file == null ? null : File(file.path);
}
