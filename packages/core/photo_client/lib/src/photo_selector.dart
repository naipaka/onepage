import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// {@template photo_selector.showPhotoSelector}
/// Shows a photo selector that allows the user to pick a single image
/// from their photo library.
///
/// Returns the selected photo ID (localIdentifier on iOS, MediaStore ID on
/// Android), or null if the user cancels the selection.
///
/// This function uses Navigator 1.0 push/pop pattern to return a value,
/// similar to [showDialog] or [showModalBottomSheet].
///
/// ### Parameters
/// - [context] : The build context.
/// - [confirmLabel] : Label for the confirmation button.
/// - [noPhotosLabel] : Label shown when no photos are available.
/// - [permissionDeniedTitle] : Title shown when permission is denied.
/// - [permissionDeniedMessage] : Message shown when permission is denied.
/// - [openSettingsLabel] : Label for the settings button.
/// {@endtemplate}
Future<String?> showPhotoSelector(
  BuildContext context, {
  required String confirmLabel,
  required String noPhotosLabel,
  required String permissionDeniedTitle,
  required String permissionDeniedMessage,
  required String openSettingsLabel,
}) async {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      settings: const RouteSettings(name: 'photo-selector'),
      builder: (context) {
        return _PhotoSelectorPage(
          confirmLabel: confirmLabel,
          noPhotosLabel: noPhotosLabel,
          permissionDeniedTitle: permissionDeniedTitle,
          permissionDeniedMessage: permissionDeniedMessage,
          openSettingsLabel: openSettingsLabel,
        );
      },
      fullscreenDialog: true,
    ),
  );
}

/// {@template photo_selector._PhotoSelectorPage}
/// Main photo selector page that manages permission state.
///
/// Requests photo library permission and displays appropriate content
/// based on the permission state.
/// {@endtemplate}
class _PhotoSelectorPage extends StatefulWidget {
  /// {@macro photo_selector._PhotoSelectorPage}
  const _PhotoSelectorPage({
    required this.confirmLabel,
    required this.noPhotosLabel,
    required this.permissionDeniedTitle,
    required this.permissionDeniedMessage,
    required this.openSettingsLabel,
  });

  final String confirmLabel;
  final String noPhotosLabel;
  final String permissionDeniedTitle;
  final String permissionDeniedMessage;
  final String openSettingsLabel;

  @override
  State<_PhotoSelectorPage> createState() => _PhotoSelectorPageState();
}

class _PhotoSelectorPageState extends State<_PhotoSelectorPage> {
  /// Current photo library permission state.
  PermissionState? _permissionState;

  @override
  void initState() {
    super.initState();
    unawaited(_requestPermission());
  }

  /// Requests photo library permission from the system.
  Future<void> _requestPermission() async {
    final state = await PhotoManager.requestPermissionExtend();
    if (!mounted) {
      return;
    }
    setState(() {
      _permissionState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_permissionState == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_permissionState!.isAuth) {
      return _PermissionDeniedView(
        permissionDeniedTitle: widget.permissionDeniedTitle,
        permissionDeniedMessage: widget.permissionDeniedMessage,
        openSettingsLabel: widget.openSettingsLabel,
      );
    }

    return _PhotoSelectorView(
      confirmLabel: widget.confirmLabel,
      noPhotosLabel: widget.noPhotosLabel,
    );
  }
}

/// {@template photo_selector._PermissionDeniedView}
/// Widget to display permission denied screen.
///
/// Shows an error message and a button to open app settings.
/// {@endtemplate}
class _PermissionDeniedView extends StatelessWidget {
  /// {@macro photo_selector._PermissionDeniedView}
  const _PermissionDeniedView({
    required this.permissionDeniedTitle,
    required this.permissionDeniedMessage,
    required this.openSettingsLabel,
  });

  final String permissionDeniedTitle;
  final String permissionDeniedMessage;
  final String openSettingsLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      color: colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        permissionDeniedTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  permissionDeniedMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      await AppSettings.openAppSettings();
                    },
                    child: Text(openSettingsLabel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// {@template photo_selector._PhotoSelectorContent}
/// Content widget that manages albums and displays album list or photo grid.
///
/// Loads available photo albums and allows switching between them.
/// {@endtemplate}
class _PhotoSelectorView extends StatefulWidget {
  /// {@macro photo_selector._PhotoSelectorContent}
  const _PhotoSelectorView({
    required this.confirmLabel,
    required this.noPhotosLabel,
  });

  final String confirmLabel;
  final String noPhotosLabel;

  @override
  State<_PhotoSelectorView> createState() => _PhotoSelectorViewState();
}

class _PhotoSelectorViewState extends State<_PhotoSelectorView> {
  /// List of available photo albums on the device.
  List<AssetPathEntity> _albums = [];

  /// Currently selected album to display photos from.
  AssetPathEntity? _selectedAlbum;

  /// Whether showing album list instead of photo grid.
  bool _showingAlbumList = false;

  /// Whether albums are currently being loaded.
  bool _isLoading = true;

  /// Currently selected photo asset by the user.
  AssetEntity? _selectedAsset;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAlbums());
  }

  /// Loads all photo albums from the device.
  Future<void> _loadAlbums() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(ignoreSize: true),
          ),
          orders: [
            const OrderOption(),
          ],
        ),
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _albums = albums;
        _selectedAlbum = albums.isNotEmpty ? albums.first : null;
        _isLoading = false;
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Toggles between photo grid and album list view.
  void _toggleAlbumList() {
    setState(() {
      _showingAlbumList = !_showingAlbumList;
    });
  }

  /// Handles album selection from the album list.
  void _onAlbumSelected(AssetPathEntity album) {
    if (album == _selectedAlbum) {
      return;
    }

    setState(() {
      _selectedAlbum = album;
      _showingAlbumList = false;
      _selectedAsset = null;
    });
  }

  /// Handles photo tap to toggle selection state.
  void _onAssetTap(AssetEntity asset) {
    setState(() {
      _selectedAsset = _selectedAsset == asset ? null : asset;
    });
  }

  /// Confirms the selection and returns the selected photo ID.
  void _onConfirm() {
    if (_selectedAsset != null) {
      Navigator.of(context).pop(_selectedAsset!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _AlbumSelectorTitle(
          selectedAlbum: _selectedAlbum,
          isExpanded: _showingAlbumList,
          onTap: _toggleAlbumList,
        ),
        centerTitle: true,
      ),
      body: _PhotoSelectorBody(
        isLoading: _isLoading,
        selectedAlbum: _selectedAlbum,
        showingAlbumList: _showingAlbumList,
        albums: _albums,
        onAlbumSelected: _onAlbumSelected,
        selectedAsset: _selectedAsset,
        onAssetTap: _onAssetTap,
        noPhotosLabel: widget.noPhotosLabel,
      ),
      floatingActionButton: !_showingAlbumList && _selectedAsset != null
          ? FilledButton(
              onPressed: _onConfirm,
              child: Text(widget.confirmLabel),
            )
          : const SizedBox.shrink(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// {@template photo_selector._AlbumSelectorTitle}
/// AppBar title widget for album selector with dropdown indicator.
///
/// Shows the current album name with an arrow indicating expand/collapse state.
/// {@endtemplate}
class _AlbumSelectorTitle extends StatelessWidget {
  /// {@macro photo_selector._AlbumSelectorTitle}
  const _AlbumSelectorTitle({
    required this.selectedAlbum,
    required this.isExpanded,
    required this.onTap,
  });

  /// Currently selected album. Returns empty widget if null.
  final AssetPathEntity? selectedAlbum;

  /// Whether the album list is currently expanded.
  final bool isExpanded;

  /// Callback when the title is tapped to toggle album list.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (selectedAlbum == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(selectedAlbum!.name),
          const SizedBox(width: 4),
          Icon(
            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            size: 20,
          ),
        ],
      ),
    );
  }
}

/// {@template photo_selector._PhotoSelectorBody}
/// Body widget that displays appropriate content based on state.
///
/// Shows loading indicator, empty state, album list, or photo grid
/// based on the current state.
/// {@endtemplate}
class _PhotoSelectorBody extends StatelessWidget {
  /// {@macro photo_selector._PhotoSelectorBody}
  const _PhotoSelectorBody({
    required this.isLoading,
    required this.selectedAlbum,
    required this.showingAlbumList,
    required this.albums,
    required this.onAlbumSelected,
    required this.selectedAsset,
    required this.onAssetTap,
    required this.noPhotosLabel,
  });

  /// Whether albums are currently being loaded.
  final bool isLoading;

  /// Currently selected album to display photos from.
  final AssetPathEntity? selectedAlbum;

  /// Whether showing album list instead of photo grid.
  final bool showingAlbumList;

  /// List of available photo albums on the device.
  final List<AssetPathEntity> albums;

  /// Callback when an album is selected from the list.
  final ValueChanged<AssetPathEntity> onAlbumSelected;

  /// Currently selected photo asset by the user.
  final AssetEntity? selectedAsset;

  /// Callback when a photo is tapped to toggle selection.
  final ValueChanged<AssetEntity> onAssetTap;

  /// Label shown when no photos are available.
  final String noPhotosLabel;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (selectedAlbum == null) {
      return Center(child: Text(noPhotosLabel));
    }

    if (showingAlbumList) {
      return _AlbumListView(
        albums: albums,
        onAlbumSelected: onAlbumSelected,
      );
    }

    return _PhotoGridView(
      key: ValueKey(selectedAlbum!.id),
      album: selectedAlbum!,
      selectedAsset: selectedAsset,
      onAssetTap: onAssetTap,
      noPhotosLabel: noPhotosLabel,
    );
  }
}

/// {@template photo_selector._AlbumListView}
/// Widget to display list of albums.
///
/// Shows all available photo albums with thumbnails and photo counts.
/// {@endtemplate}
class _AlbumListView extends StatelessWidget {
  /// {@macro photo_selector._AlbumListView}
  const _AlbumListView({
    required this.albums,
    required this.onAlbumSelected,
  });

  final List<AssetPathEntity> albums;
  final ValueChanged<AssetPathEntity> onAlbumSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return _AlbumListItem(
          album: album,
          onTap: () {
            onAlbumSelected(album);
          },
        );
      },
    );
  }
}

/// {@template photo_selector._PhotoGridView}
/// Widget for photo grid display with selection and pagination.
///
/// Displays photos from the selected album in a grid layout with
/// progressive loading for performance optimization.
/// {@endtemplate}
class _PhotoGridView extends StatefulWidget {
  /// {@macro photo_selector._PhotoGridView}
  const _PhotoGridView({
    super.key,
    required this.album,
    required this.selectedAsset,
    required this.onAssetTap,
    required this.noPhotosLabel,
  });

  final AssetPathEntity album;
  final AssetEntity? selectedAsset;
  final ValueChanged<AssetEntity> onAssetTap;
  final String noPhotosLabel;

  @override
  State<_PhotoGridView> createState() => _PhotoGridViewState();
}

class _PhotoGridViewState extends State<_PhotoGridView> {
  /// List of photo assets in the currently selected album.
  final List<AssetEntity> _assets = [];

  /// Next page number to load for pagination (0-indexed).
  int _currentPage = 0;

  /// Whether there are more assets to load.
  bool _hasMore = true;

  /// Whether currently loading assets.
  bool _isLoading = false;

  /// Number of assets to load per page.
  static const int _pageSize = 80;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPage());
  }

  /// Loads a page of assets from the album.
  ///
  /// Uses [_currentPage] to load the next page of assets. Increments
  /// [_currentPage] after successful load for the next pagination.
  Future<void> _loadPage() async {
    if (!_hasMore || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final assets = await widget.album.getAssetListPaged(
        page: _currentPage,
        size: _pageSize,
      );

      if (!mounted) {
        return;
      }
      setState(() {
        _assets.addAll(assets);
        _currentPage++;
        _hasMore = assets.length >= _pageSize;
        _isLoading = false;
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _currentPage == 0) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_assets.isEmpty) {
      return Center(child: Text(widget.noPhotosLabel));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
      ),
      // Display one extra item to show a loading indicator
      // while loading more items.
      itemCount: _assets.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the end of the grid
        if (index >= _assets.length) {
          return _LoadingIndicatorItem(
            isLoadingMore: _isLoading,
            onLoadMore: _loadPage,
          );
        }

        final asset = _assets[index];
        final isSelected = widget.selectedAsset == asset;

        return GestureDetector(
          onTap: () => widget.onAssetTap(asset),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _AssetThumbnail(asset: asset),
              if (isSelected) ...[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// {@template photo_selector._LoadingIndicatorItem}
/// A widget that triggers pagination when it becomes visible.
///
/// Uses [VisibilityDetector] to detect when the user has scrolled
/// near the end of the grid and triggers loading more photos.
/// {@endtemplate}
class _LoadingIndicatorItem extends StatelessWidget {
  /// {@macro photo_selector._LoadingIndicatorItem}
  const _LoadingIndicatorItem({
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  /// Whether currently loading more assets.
  final bool isLoadingMore;

  /// Callback to trigger loading more assets.
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('loading-indicator'),
      onVisibilityChanged: (info) {
        // Trigger loading when the indicator becomes visible
        if (info.visibleFraction > 0.1 && !isLoadingMore) {
          onLoadMore();
        }
      },
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// {@template photo_selector._AlbumListItem}
/// A list item widget that displays album information.
///
/// Shows album thumbnail, name, and photo count.
/// {@endtemplate}
class _AlbumListItem extends StatefulWidget {
  /// {@macro photo_selector._AlbumListItem}
  const _AlbumListItem({
    required this.album,
    required this.onTap,
  });

  final AssetPathEntity album;

  final VoidCallback onTap;

  @override
  State<_AlbumListItem> createState() => _AlbumListItemState();
}

class _AlbumListItemState extends State<_AlbumListItem> {
  /// Thumbnail asset for the album.
  AssetEntity? _thumbnailAsset;

  /// Number of photos in the album.
  int _assetCount = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAlbumInfo());
  }

  /// Loads album thumbnail and asset count.
  Future<void> _loadAlbumInfo() async {
    final count = await widget.album.assetCountAsync;
    final assets = await widget.album.getAssetListPaged(page: 0, size: 1);

    if (!mounted) {
      return;
    }
    setState(() {
      _assetCount = count;
      _thumbnailAsset = assets.isNotEmpty ? assets.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: SizedBox(
        width: 60,
        height: 60,
        child: _thumbnailAsset != null
            ? _AssetThumbnail(asset: _thumbnailAsset!)
            : Container(
                color: colorScheme.surfaceContainerHighest,
              ),
      ),
      title: Text(widget.album.name),
      subtitle: Text('$_assetCount'),
      onTap: widget.onTap,
    );
  }
}

/// {@template photo_selector._AssetThumbnail}
/// A widget that displays a thumbnail image for a photo asset.
///
/// The thumbnail is loaded asynchronously and displayed once available.
/// {@endtemplate}
class _AssetThumbnail extends StatefulWidget {
  /// {@macro photo_selector._AssetThumbnail}
  const _AssetThumbnail({required this.asset});

  final AssetEntity asset;

  @override
  State<_AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<_AssetThumbnail> {
  /// Thumbnail image data loaded from the asset.
  Uint8List? _thumbnailData;

  /// Whether an error occurred while loading the thumbnail.
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadThumbnail());
  }

  /// Loads the thumbnail image data from the asset.
  Future<void> _loadThumbnail() async {
    try {
      final data = await widget.asset.thumbnailDataWithSize(
        const ThumbnailSize.square(300),
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _thumbnailData = data;
      });
    } on Exception {
      if (!mounted) {
        return;
      }
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Icon(
        Icons.broken_image,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      );
    }

    if (_thumbnailData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Image.memory(
      _thumbnailData!,
      fit: BoxFit.cover,
    );
  }
}
