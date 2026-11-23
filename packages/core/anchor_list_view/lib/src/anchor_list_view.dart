import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'anchor_item_position.dart';
import 'range_scroll_view.dart';

/// {@template anchor_list_view.AnchorListController}
/// Controls an [AnchorListView].
///
/// The scroll offset is measured as in a [CustomScrollView] with a center
/// sliver: 0 is the offset at which the center item is at the alignment. A
/// move to an item far from the visible items makes that item the center
/// item, which moves the place of offset 0.
/// {@endtemplate}
class AnchorListController extends ScrollController {
  /// {@macro anchor_list_view.AnchorListController}
  new() : super(keepScrollOffset: false);

  final Set<_AnchorListViewState> _views = {};

  /// Moves the item at [index] to [alignment] without animation.
  ///
  /// [alignment] is a fraction of the viewport extent: 0 puts the top of
  /// the item at the top of the viewport, and 1 at the bottom.
  void jumpToItem(int index, {double alignment = 0}) {
    assert(_views.isNotEmpty, 'AnchorListController is not attached.');
    for (final view in _views.toList()) {
      view._jumpToItem(index, alignment);
    }
  }

  /// Animates the item at [index] to [alignment].
  ///
  /// When the item is far from the visible items, the list fades out, moves
  /// near the item, and fades in while scrolling to it.
  Future<void> animateToItem(
    int index, {
    double alignment = 0,
    required Duration duration,
    required Curve curve,
  }) {
    assert(_views.isNotEmpty, 'AnchorListController is not attached.');
    return Future.wait([
      for (final view in _views.toList())
        view._animateToItem(index, alignment, duration, curve),
    ]);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return AnchorScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
    );
  }
}

/// {@template anchor_list_view.AnchorListView}
/// A scrollable list that moves to any item by its index, including items
/// that are not built yet, and reports the items in the viewport.
///
/// The list keeps the item at its center in place when items are inserted
/// or removed before it, when it can find the item again with the
/// find-index callback.
/// {@endtemplate}
class AnchorListView extends StatefulWidget {
  /// {@macro anchor_list_view.AnchorListView}
  ///
  /// Builds the items on demand, as [ListView.builder].
  const new builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    int? Function(Key key)? findChildIndexCallback,
    this.initialIndex = 0,
    this.initialAlignment = 0,
    this.controller,
    this.onPositionsChanged,
    this.physics,
    this.padding = EdgeInsets.zero,
  }) : separatorBuilder = null,
       _findItemIndex = findChildIndexCallback;

  /// {@macro anchor_list_view.AnchorListView}
  ///
  /// Builds the items with separators between them, as
  /// [ListView.separated].
  const new separated({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required IndexedWidgetBuilder this.separatorBuilder,
    int? Function(Key key)? findItemIndexCallback,
    this.initialIndex = 0,
    this.initialAlignment = 0,
    this.controller,
    this.onPositionsChanged,
    this.physics,
    this.padding = EdgeInsets.zero,
  }) : _findItemIndex = findItemIndexCallback;

  /// The number of items.
  final int itemCount;

  /// Builds the item at the index.
  final IndexedWidgetBuilder itemBuilder;

  /// Builds the separator after the item at the index.
  final IndexedWidgetBuilder? separatorBuilder;

  /// Returns the index of the item whose widget has the key.
  ///
  /// With it, the list keeps the states of the items, and the position of
  /// the center item, when items are inserted or removed. Without it, the
  /// center item keeps its index, as in a [ListView].
  final int? Function(Key key)? _findItemIndex;

  /// The index of the item shown first.
  final int initialIndex;

  /// Where the item at [initialIndex] is shown first, as a fraction of the
  /// viewport extent: 0 is the top and 1 is the bottom.
  final double initialAlignment;

  /// Moves the list to items. The list creates its own when it is null.
  final AnchorListController? controller;

  /// Called with the items at least partly in the viewport, from top to
  /// bottom, when they or their positions differ from the last call.
  final ValueChanged<List<AnchorItemPosition>>? onPositionsChanged;

  /// How the list responds to user input.
  final ScrollPhysics? physics;

  /// The space around the items.
  final EdgeInsets padding;

  @override
  State<AnchorListView> createState() => _AnchorListViewState();
}

class _AnchorListViewState extends State<AnchorListView>
    with SingleTickerProviderStateMixin {
  /// How far from the visible area, in viewports on each side, an item is
  /// near enough to scroll to.
  static const _nearViewports = 2.0;

  late final _fade = AnimationController(vsync: this, value: 1);
  final _centerKey = GlobalKey();
  final Set<_MarkerState> _mounted = {};
  AnchorListController? _ownController;
  bool _positionsScheduled = false;
  List<AnchorItemPosition>? _lastPositions;

  /// The index of the item at the center of the scroll coordinates.
  late int _target;

  /// The key of the widget built for [_target], used to find the item again
  /// when the items change.
  Key? _targetKey;

  late double _alignment;

  /// Counts the changes of the center item. The slivers before and after
  /// the center item are keyed by it, because their children hold layout
  /// offsets measured from the old center.
  int _generation = 0;

  AnchorListController get _controller =>
      widget.controller ?? (_ownController ??= AnchorListController());

  ScrollPosition? get _position {
    final context = _centerKey.currentContext;
    return context == null ? null : Scrollable.maybeOf(context)?.position;
  }

  @override
  void initState() {
    super.initState();
    _target = widget.initialIndex;
    _alignment = widget.initialAlignment;
    _controller._views.add(this);
  }

  @override
  void didUpdateWidget(AnchorListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownController)?._views.remove(this);
      if (widget.controller != null) {
        _ownController?.dispose();
        _ownController = null;
      }
      _controller._views.add(this);
    }
    final key = _targetKey;
    final found = key == null ? null : widget._findItemIndex?.call(key);
    if (found != null) {
      _target = found;
    } else if (_target >= widget.itemCount) {
      _setTarget(math.max(0, widget.itemCount - 1));
    }
  }

  void _setTarget(int index) {
    if (index != _target) {
      _target = index;
      _targetKey = null;
      _generation++;
    }
  }

  @override
  void dispose() {
    _controller._views.remove(this);
    _ownController?.dispose();
    _fade.dispose();
    super.dispose();
  }

  void _jumpToItem(int index, double alignment) {
    final position = _position!;
    final offset = _offsetToReveal(index, alignment);
    if (offset != null) {
      position.jumpTo(
        clampDouble(offset, position.minScrollExtent, position.maxScrollExtent),
      );
      return;
    }
    setState(() {
      _setTarget(index);
      _alignment = alignment;
    });
    position.jumpTo(0);
  }

  Future<void> _animateToItem(
    int index,
    double alignment,
    Duration duration,
    Curve curve,
  ) async {
    final position = _position!;
    if (_isNear(index, position)) {
      await position.animateTo(
        _offsetToReveal(index, alignment)!,
        duration: duration,
        curve: curve,
      );
      return;
    }
    final height = position.viewportDimension;
    final direction = index > _firstVisible() ? 1.0 : -1.0;
    final out = duration * 0.3;
    await Future.wait([
      _fade.animateTo(0, duration: out, curve: Curves.easeIn),
      position.animateTo(
        position.pixels + direction * 0.5 * height,
        duration: out,
        curve: Curves.easeIn,
      ),
    ]);
    setState(() {
      _setTarget(index);
      _alignment = alignment;
    });
    position.jumpTo(-direction * height);
    await SchedulerBinding.instance.endOfFrame;
    final rest = duration - out;
    await Future.wait([
      _fade.animateTo(1, duration: rest * 0.6, curve: Curves.easeOut),
      position.animateTo(0, duration: rest, curve: Curves.easeOut),
    ]);
  }

  /// Whether the item is laid out within [_nearViewports] of the visible
  /// area.
  bool _isNear(int index, ScrollPosition position) {
    final box = _boxOf(index);
    final leading = box == null ? null : _offsetOf(box, 0);
    if (box == null || leading == null) {
      return false;
    }
    final extent = position.viewportDimension;
    final top = (leading - position.pixels) / extent;
    final bottom = top + box.size.height / extent;
    return bottom > -_nearViewports && top < 1 + _nearViewports;
  }

  int _firstVisible() {
    final visible = _visiblePositions();
    return visible.isEmpty ? _target : visible.first.index;
  }

  RenderBox? _boxOf(int index) {
    for (final marker in _mounted) {
      if (marker.widget.index == index) {
        final box = marker.context.findRenderObject();
        return box is RenderBox ? box : null;
      }
    }
    return null;
  }

  double? _offsetToReveal(int index, double alignment) {
    final box = _boxOf(index);
    return box == null ? null : _offsetOf(box, alignment);
  }

  /// The scroll offset that puts the leading edge of a laid-out box at
  /// [alignment], or null when the box is not laid out.
  static double? _offsetOf(RenderBox box, double alignment) {
    if (!box.hasSize || !box.attached || !_laidOut(box)) {
      return null;
    }
    final viewport = RenderAbstractViewport.of(box);
    if (viewport is! RenderViewport) {
      return null;
    }
    final extent = viewport.size.height;
    final leading = viewport.getOffsetToReveal(box, 0).offset;
    return leading + (viewport.anchor - alignment) * extent;
  }

  /// Whether the sliver list that holds the box has given it a layout
  /// offset. A kept-alive or cached child can be attached without one.
  static bool _laidOut(RenderBox box) {
    RenderObject child = box;
    for (var parent = child.parent; parent != null; parent = parent.parent) {
      if (parent is RenderSliver) {
        final data = child.parentData;
        return data is! SliverMultiBoxAdaptorParentData ||
            data.layoutOffset != null;
      }
      child = parent;
    }
    return false;
  }

  List<AnchorItemPosition> _visiblePositions() {
    final position = _position;
    if (position == null || !position.hasViewportDimension) {
      return const [];
    }
    final extent = position.viewportDimension;
    final positions = <AnchorItemPosition>[];
    for (final marker in _mounted) {
      final box = marker.context.findRenderObject();
      if (box is! RenderBox) {
        continue;
      }
      final offset = _offsetOf(box, 0);
      if (offset == null) {
        continue;
      }
      final leading = (offset - position.pixels) / extent;
      final trailing = leading + box.size.height / extent;
      if (trailing > 0 && leading < 1) {
        positions.add(
          AnchorItemPosition(
            index: marker.widget.index,
            leadingEdge: leading,
            trailingEdge: trailing,
          ),
        );
      }
    }
    positions.sort((a, b) => a.leadingEdge.compareTo(b.leadingEdge));
    return positions;
  }

  void _schedulePositions() {
    if (_positionsScheduled) {
      return;
    }
    _positionsScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _positionsScheduled = false;
      final callback = widget.onPositionsChanged;
      if (!mounted || callback == null) {
        return;
      }
      final positions = _visiblePositions();
      if (!listEquals(positions, _lastPositions)) {
        _lastPositions = positions;
        callback(positions);
      }
    });
  }

  bool _onScroll(Notification notification) {
    if (notification is ScrollNotification && notification.depth == 0 ||
        notification is ScrollMetricsNotification && notification.depth == 0) {
      _schedulePositions();
    }
    return false;
  }

  /// The child index, in the sliver before or after the center item [t], of
  /// the item whose widget has [key]. Items and separators alternate when
  /// there are separators, each separator first, counted outward from the
  /// center.
  int? _childIndex(Key key, int t, {required bool before}) {
    final i = widget._findItemIndex?.call(key);
    if (i == null) {
      return null;
    }
    final separated = widget.separatorBuilder != null;
    if (before) {
      if (i >= t) {
        return null;
      }
      return separated ? 2 * (t - 1 - i) + 1 : t - 1 - i;
    }
    if (i <= t) {
      return null;
    }
    return separated ? 2 * (i - t - 1) + 1 : i - t - 1;
  }

  Widget _item(BuildContext context, int index) {
    final child = widget.itemBuilder(context, index);
    if (index == _target) {
      _targetKey = child.key;
    }
    return _Marker(
      key: child.key,
      index: index,
      registry: _mounted,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    _schedulePositions();
    final count = widget.itemCount;
    final t = _target;
    final separator = widget.separatorBuilder;
    return NotificationListener<Notification>(
      onNotification: _onScroll,
      child: FadeTransition(
        opacity: _fade,
        child: RangeScrollView(
          controller: _controller,
          center: _centerKey,
          anchor: _alignment,
          physics: widget.physics,
          slivers: [
            SliverPadding(
              key: ValueKey(('before', _generation)),
              padding: widget.padding.copyWith(bottom: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, c) => separator != null
                      ? (c.isEven
                            ? separator(context, t - 1 - c ~/ 2)
                            : _item(context, t - 1 - c ~/ 2))
                      : _item(context, t - 1 - c),
                  childCount: separator != null ? 2 * t : t,
                  findChildIndexCallback: (key) =>
                      _childIndex(key, t, before: true),
                ),
              ),
            ),
            SliverPadding(
              key: _centerKey,
              padding: widget.padding.copyWith(top: 0, bottom: 0),
              sliver: SliverToBoxAdapter(
                child: count == 0
                    ? null
                    : Builder(builder: (context) => _item(context, t)),
              ),
            ),
            SliverPadding(
              key: ValueKey(('after', _generation)),
              padding: widget.padding.copyWith(top: 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, c) => separator != null
                      ? (c.isEven
                            ? separator(context, t + c ~/ 2)
                            : _item(context, t + 1 + c ~/ 2))
                      : _item(context, t + 1 + c),
                  childCount: separator != null
                      ? 2 * math.max(0, count - t - 1)
                      : math.max(0, count - t - 1),
                  findChildIndexCallback: (key) =>
                      _childIndex(key, t, before: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Registers the state of a built item, so that the list can find the
/// render box of an item by its index.
class _Marker extends StatefulWidget {
  const new({
    super.key,
    required this.index,
    required this.registry,
    required this.child,
  });

  final int index;
  final Set<_MarkerState> registry;
  final Widget child;

  @override
  State<_Marker> createState() => _MarkerState();
}

class _MarkerState extends State<_Marker> {
  @override
  void initState() {
    super.initState();
    widget.registry.add(this);
  }

  @override
  void dispose() {
    widget.registry.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
