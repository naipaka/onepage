import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// {@template anchor_list_view.RangeScrollView}
/// A [CustomScrollView] whose scroll range stops at the ends of its slivers,
/// measured from the slivers laid out around the center sliver.
///
/// Its controller must create an [AnchorScrollPosition].
/// {@endtemplate}
class RangeScrollView extends CustomScrollView {
  /// {@macro anchor_list_view.RangeScrollView}
  const new({
    super.controller,
    super.center,
    super.anchor,
    super.physics,
    super.slivers,
  });

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset offset,
    AxisDirection axisDirection,
    List<Widget> slivers,
  ) {
    return _RangeViewport(
      axisDirection: axisDirection,
      offset: offset,
      center: center,
      anchor: anchor,
      slivers: slivers,
    );
  }
}

class _RangeViewport extends Viewport {
  new({
    required super.axisDirection,
    required super.offset,
    super.center,
    super.anchor,
    super.slivers,
  });

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return _RangeRenderViewport(
      axisDirection: axisDirection,
      crossAxisDirection: Viewport.getDefaultCrossAxisDirection(
        context,
        axisDirection,
      ),
      anchor: anchor,
      offset: offset,
    );
  }
}

class _RangeRenderViewport extends RenderViewport {
  new({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    super.anchor,
  });

  @override
  void performLayout() {
    final position = offset;
    assert(
      position is AnchorScrollPosition,
      'The controller of a RangeScrollView must create an '
      'AnchorScrollPosition.',
    );
    if (position is AnchorScrollPosition) {
      position._rangeSource = this;
    }
    super.performLayout();
  }

  /// The scroll range that stops at the ends of the slivers, from their
  /// extents in the current layout.
  ///
  /// Slivers shorter than the viewport start at the top, as in a [ListView].
  ({double min, double max})? computeRange() {
    final center = this.center;
    if (center == null) {
      return null;
    }
    var reverse = 0.0;
    for (
      var sliver = childBefore(center);
      sliver != null;
      sliver = childBefore(sliver)
    ) {
      reverse += sliver.geometry?.scrollExtent ?? 0;
    }
    var forward = 0.0;
    for (
      RenderSliver? sliver = center;
      sliver != null;
      sliver = childAfter(sliver)
    ) {
      forward += sliver.geometry?.scrollExtent ?? 0;
    }
    final extent = switch (axis) {
      Axis.vertical => size.height,
      Axis.horizontal => size.width,
    };
    final top = -reverse + extent * anchor;
    final bottom = forward - extent * (1 - anchor);
    if (reverse + forward <= extent) {
      return (min: top, max: top);
    }
    final max = math.max(math.min(0.0, top), bottom);
    return (min: math.min(top, max), max: max);
  }
}

/// {@template anchor_list_view.AnchorScrollPosition}
/// The scroll position of a [RangeScrollView], which takes its scroll range
/// from the viewport.
///
/// It keeps the first layout and programmatic animations within the range.
/// {@endtemplate}
class AnchorScrollPosition extends ScrollPositionWithSingleContext {
  /// {@macro anchor_list_view.AnchorScrollPosition}
  new({
    required super.physics,
    required super.context,
    super.oldPosition,
  }) : super(keepScrollOffset: false);

  _RangeRenderViewport? _rangeSource;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final range = _rangeSource?.computeRange();
    final min = range?.min ?? minScrollExtent;
    final max = range?.max ?? maxScrollExtent;
    if (!haveDimensions && (pixels < min || pixels > max)) {
      correctPixels(clampDouble(pixels, min, max));
      return false;
    }
    return super.applyContentDimensions(min, max);
  }

  @override
  double applyBoundaryConditions(double value) {
    if (activity is DrivenScrollActivity) {
      if (value < minScrollExtent && minScrollExtent <= pixels) {
        return value - minScrollExtent;
      }
      if (value > maxScrollExtent && maxScrollExtent >= pixels) {
        return value - maxScrollExtent;
      }
    }
    return super.applyBoundaryConditions(value);
  }
}
