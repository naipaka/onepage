import 'package:flutter/foundation.dart';

/// {@template anchor_list_view.AnchorItemPosition}
/// Where an item of an `AnchorListView` is in the viewport.
///
/// The edges are fractions of the viewport extent in the scroll direction:
/// 0 is the leading edge of the viewport, such as the top of a vertical list,
/// and 1 is the trailing edge, on the same scale as the alignment of
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

  /// The position of the leading edge of the item.
  final double leadingEdge;

  /// The position of the trailing edge of the item.
  final double trailingEdge;

  @override
  bool operator ==(Object other) =>
      other is AnchorItemPosition &&
      other.index == index &&
      other.leadingEdge == leadingEdge &&
      other.trailingEdge == trailingEdge;

  @override
  int get hashCode => Object.hash(index, leadingEdge, trailingEdge);

  @override
  String toString() =>
      'AnchorItemPosition(index: $index, leadingEdge: $leadingEdge, '
      'trailingEdge: $trailingEdge)';
}
