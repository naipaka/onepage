import 'package:flutter/foundation.dart';

/// {@template anchor_list_view.AnchorItemPosition}
/// Where an item of an `AnchorListView` is in the viewport.
///
/// The edges are fractions of the viewport extent: 0 is the top of the
/// viewport and 1 is the bottom, on the same scale as the alignment of
/// `AnchorListController.jumpToItem`.
/// {@endtemplate}
@immutable
class AnchorItemPosition {
  /// {@macro anchor_list_view.AnchorItemPosition}
  const new({
    required this.index,
    required this.leadingEdge,
    required this.trailingEdge,
  });

  /// The index of the item.
  final int index;

  /// The position of the top of the item.
  final double leadingEdge;

  /// The position of the bottom of the item.
  final double trailingEdge;

  @override
  bool operator ==(Object other) =>
      other is AnchorItemPosition &&
      other.index == index &&
      other.leadingEdge == leadingEdge &&
      other.trailingEdge == trailingEdge;

  @override
  int get hashCode => Object.hash(index, leadingEdge, trailingEdge);
}
