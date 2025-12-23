import 'package:flutter/material.dart';

/// A button widget that allows selecting an image from the device's photo
/// library.
class ImageSelectionActionButton extends StatelessWidget {
  /// Creates an image selection action button.
  const ImageSelectionActionButton({
    super.key,
    this.onSelected,
    this.onError,
  });

  /// Called when an image is selected with the photo ID.
  ///
  /// If null, the button will be disabled.
  final ValueChanged<String>? onSelected;

  /// Called when an error occurs during image selection.
  final ValueChanged<Object>? onError;

  @override
  Widget build(BuildContext context) {
    void selectImage() {
      // TODO(naipaka): Implement image selection logic here.
    }

    return IconButton(
      onPressed: onSelected != null ? selectImage : null,
      icon: const Icon(Icons.add_photo_alternate_outlined),
    );
  }
}
