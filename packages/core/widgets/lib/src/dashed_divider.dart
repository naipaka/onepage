import 'package:flutter/material.dart';

/// {@template widgets.DashedDivider}
/// A dashed divider line.
///
/// This widget draws a dashed line with a specified width, height, and space
/// between dashes.
/// {@endtemplate}
class DashedDivider extends StatelessWidget {
  /// {@macro widgets.DashedDivider}
  const DashedDivider({
    super.key,
    this.dashedWidth = 5,
    this.dashedHeight = 1,
    this.dashedSpace = 5,
    this.color,
  });

  /// The width of a single dash.
  final double dashedWidth;

  /// The height of the dash.
  final double dashedHeight;

  /// The space between dashes.
  final double dashedSpace;

  /// The color of the dash.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: dashedHeight,
      child: CustomPaint(
        painter: _DashedLinePainter(
          dashedWidth: dashedWidth,
          dashedHeight: dashedHeight,
          dashedSpace: dashedSpace,
          color: color ?? Theme.of(context).dividerColor,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({
    required this.dashedWidth,
    required this.dashedHeight,
    required this.dashedSpace,
    required this.color,
  });

  /// The width of a single dash.
  final double dashedWidth;

  /// The height of the dash.
  final double dashedHeight;

  /// The space between dashes.
  final double dashedSpace;

  /// The color of the dash.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var dashedStartX = 0.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = dashedHeight;
    while (dashedStartX < size.width) {
      // Start point.
      final startOffset = Offset(dashedStartX, 0);
      // End point.
      final endOffset = Offset(dashedStartX + dashedWidth, 0);
      // Draw from start point to end point.
      canvas.drawLine(startOffset, endOffset, paint);
      // Update the X coordinate of the start point.
      dashedStartX = dashedStartX + dashedWidth + dashedSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
