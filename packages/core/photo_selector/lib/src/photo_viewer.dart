import 'dart:async';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

/// {@template photo_selector.PhotoThumbnail}
/// A widget that displays a photo thumbnail from a photo ID.
///
/// Loads the photo asynchronously using [PhotoManager] and displays it
/// as a thumbnail. Tapping the thumbnail opens a full-screen viewer
/// with pinch-zoom capabilities.
///
/// If the photo cannot be loaded (e.g., deleted from device), displays
/// an error icon instead.
///
/// ### Parameters
/// - [photoId] : The photo ID (localIdentifier on iOS, MediaStore ID on
///   Android).
/// - [width] : The width of the thumbnail in logical pixels.
/// - [height] : The height of the thumbnail in logical pixels.
/// - [onDelete] : Callback when the delete button is pressed in the viewer.
///
/// Unlike [Image], width and height are required to optimize memory usage by
/// loading appropriately sized thumbnails based on device pixel ratio.
/// {@endtemplate}
class PhotoThumbnail extends StatefulWidget {
  /// {@macro photo_selector.PhotoThumbnail}
  const PhotoThumbnail({
    required this.photoId,
    required this.width,
    required this.height,
    this.onDelete,
    super.key,
  });

  /// The photo ID to display.
  final String photoId;

  /// The width of the thumbnail in logical pixels.
  final double width;

  /// The height of the thumbnail in logical pixels.
  final double height;

  /// Callback when the delete button is pressed in the viewer.
  final VoidCallback? onDelete;

  @override
  State<PhotoThumbnail> createState() => _PhotoThumbnailState();
}

class _PhotoThumbnailState extends State<PhotoThumbnail> {
  /// The asset entity loaded from the photo ID.
  AssetEntity? _asset;

  /// Whether an error occurred while loading the asset.
  bool _hasError = false;

  /// Unique tag for Hero animation.
  final _heroTag = UniqueKey();

  @override
  void initState() {
    super.initState();
    unawaited(_loadAsset());
  }

  /// Loads the asset entity from the photo ID.
  Future<void> _loadAsset() async {
    try {
      final asset = await AssetEntity.fromId(widget.photoId);
      if (!mounted) {
        return;
      }
      setState(() {
        _asset = asset;
        _hasError = asset == null;
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() {
        _asset = null;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final asset = _asset;

    if (_hasError) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    if (asset == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final thumbnailSize = ThumbnailSize(
      (widget.width * pixelRatio).toInt(),
      (widget.height * pixelRatio).toInt(),
    );

    Future<void> showPhotoViewer() async {
      await Navigator.of(context).push<void>(
        PageRouteBuilder(
          pageBuilder: (_, _, _) {
            return _PhotoViewer(
              heroTag: _heroTag,
              asset: asset,
              onDelete: widget.onDelete,
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
        tag: _heroTag,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: AssetEntityImage(
            asset,
            isOriginal: false,
            thumbnailSize: thumbnailSize,
            fit: BoxFit.cover,
            width: widget.width,
            height: widget.height,
          ),
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
  const _PhotoViewer({
    required this.heroTag,
    required this.asset,
    this.onDelete,
  });

  /// Unique tag for Hero animation.
  final Object heroTag;

  /// The asset entity to display.
  final AssetEntity asset;

  /// Callback when the delete button is pressed.
  final VoidCallback? onDelete;

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
      final height = MediaQuery.sizeOf(context).height;
      _opacity = (1 - (_offset.distance / height)).clamp(0.0, 1.0);
    });
  }

  /// Handles vertical drag end for drag-to-dismiss gesture.
  void _onVerticalDragEnd(DragEndDetails details) {
    final height = MediaQuery.sizeOf(context).height;
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
          if (widget.onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onDelete,
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
                  child: AssetEntityImage(
                    widget.asset,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
