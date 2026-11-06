import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

/// {@template photo_client.PhotoPlaceholder}
/// A placeholder for a photo that is not stored in the app.
/// {@endtemplate}
class PhotoPlaceholder extends StatelessWidget {
  /// {@macro photo_client.PhotoPlaceholder}
  const new({
    super.key,
    required this.width,
    required this.height,
    required this.onTap,
  });

  /// The width of the placeholder in logical pixels.
  final double width;

  /// The height of the placeholder in logical pixels.
  final double height;

  /// Called when the placeholder is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _BrokenPhoto(width: width, height: height),
      ),
    );
  }
}

/// {@template photo_client.PhotoFileThumbnail}
/// A widget that displays a thumbnail of a photo file.
///
/// Tapping the thumbnail opens a full-screen viewer with zoom and optional
/// delete functionality.
///
/// ### Parameters
/// - [file] : The photo file to display.
/// - [width] : The width of the thumbnail in logical pixels.
/// - [height] : The height of the thumbnail in logical pixels.
/// - [onDeleted] : Called when the delete button is pressed.
/// - [onInfoShown] : Called when the info button is pressed.
/// {@endtemplate}
class PhotoFileThumbnail extends StatelessWidget {
  /// {@macro photo_client.PhotoFileThumbnail}
  const new({
    super.key,
    required this.file,
    required this.width,
    required this.height,
    this.onDeleted,
    this.onInfoShown,
  });

  /// The photo file to display.
  final File file;

  /// The width of the thumbnail in logical pixels.
  final double width;

  /// The height of the thumbnail in logical pixels.
  final double height;

  /// Callback when the delete button is pressed.
  final VoidCallback? onDeleted;

  /// Callback when the info button is pressed.
  final VoidCallback? onInfoShown;

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final cacheSize = (max(width, height) * pixelRatio * 2).toInt();
    final heroTag = file.path;

    Future<void> showPhotoViewer() async {
      await Navigator.of(context).push<void>(
        PageRouteBuilder(
          pageBuilder: (_, _, _) {
            return _PhotoViewer(
              heroTag: heroTag,
              image: Image.file(
                file,
                errorBuilder: (_, _, _) => const _BrokenPhoto(),
              ),
              onDeleted: onDeleted,
              onInfoShown: onInfoShown,
            );
          },
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }

    return GestureDetector(
      onTap: showPhotoViewer,
      child: Hero(
        tag: heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image(
            image: ResizeImage(
              FileImage(file),
              width: cacheSize,
              height: cacheSize,
              policy: ResizeImagePolicy.fit,
            ),
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return _BrokenPhoto(width: width, height: height);
            },
          ),
        ),
      ),
    );
  }
}

/// {@template photo_client._BrokenPhoto}
/// A placeholder shown when a photo file cannot be read.
/// {@endtemplate}
class _BrokenPhoto extends StatelessWidget {
  /// {@macro photo_client._BrokenPhoto}
  const new({this.width, this.height});

  /// The width of the placeholder in logical pixels.
  final double? width;

  /// The height of the placeholder in logical pixels.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

/// {@template photo_selector._PhotoViewer}
/// Displays a photo in full-screen mode.
///
/// This widget loads the high-resolution version of the photo and displays
/// it in a full-screen view with interactive zoom and pan capabilities.
/// Supports drag-to-dismiss gesture and optional delete functionality.
/// {@endtemplate}
class _PhotoViewer extends StatefulWidget {
  /// {@macro photo_selector._PhotoViewer}
  const new({
    required this.heroTag,
    required this.image,
    this.onDeleted,
    this.onInfoShown,
  });

  /// Unique tag for Hero animation.
  final Object heroTag;

  /// The full-size image to display.
  final Widget image;

  /// Callback when the delete button is pressed.
  final VoidCallback? onDeleted;

  /// Callback when the info button is pressed.
  final VoidCallback? onInfoShown;

  @override
  State<_PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<_PhotoViewer> {
  /// Offset for drag-to-dismiss gesture.
  var _offset = Offset.zero;

  /// Opacity for drag-to-dismiss gesture.
  var _opacity = 1.0;

  /// InteractiveViewer controller to track zoom state.
  final _controller = TransformationController();

  /// Current zoom scale.
  var _scale = 1.0;

  /// Whether the image is currently zoomed.
  bool get _isScaling => _scale != 1.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Handles vertical drag updates for drag-to-dismiss gesture.
  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
      final height = MediaQuery.heightOf(context);
      _opacity = (1 - (_offset.distance / height)).clamp(0.0, 1.0);
    });
  }

  /// Handles vertical drag end for drag-to-dismiss gesture.
  void _onVerticalDragEnd(DragEndDetails details) {
    final height = MediaQuery.heightOf(context);
    if (_offset.distance > height * 0.2) {
      Navigator.pop(context);
    } else {
      setState(() {
        _offset = Offset.zero;
        _opacity = 1.0;
      });
    }
  }

  /// Handles interaction end to update zoom scale.
  void _onInteractionEnd(ScaleEndDetails details) {
    setState(() {
      _scale = _controller.value.getMaxScaleOnAxis();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (widget.onInfoShown != null)
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: widget.onInfoShown,
            ),
          if (widget.onDeleted != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onDeleted,
            ),
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: _isScaling ? null : _onVerticalDragUpdate,
        onVerticalDragEnd: _isScaling ? null : _onVerticalDragEnd,
        child: Opacity(
          opacity: _isScaling ? 1.0 : _opacity,
          child: Transform.translate(
            offset: _isScaling ? Offset.zero : _offset,
            child: SizedBox.expand(
              child: Hero(
                tag: widget.heroTag,
                child: InteractiveViewer(
                  transformationController: _controller,
                  onInteractionEnd: _onInteractionEnd,
                  maxScale: 5,
                  clipBehavior: Clip.none,
                  child: widget.image,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
