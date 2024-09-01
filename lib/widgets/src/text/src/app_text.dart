import 'package:flutter/material.dart';

import '../../../../theme/theme.dart';

/// Types of typography available for use with [AppText].
enum _AppTypographyType {
  bodyS,
  bodyM,
  bodyL,
  bodySBold,
  bodyMBold,
  bodyLBold,
}

/// A wrapper widget for [Text] that is the standard for use in the app.
class AppText extends StatelessWidget {
  /// Creates a new body small [AppText] instance.
  const AppText.bodyS(
    this.data, {
    super.key,
    this.color,
    this.indentLevel,
    this.indentSize,
    this.maxLines,
    this.textAlign,
    this.decoration,
    this.shrinkLineHeight,
  })  : type = _AppTypographyType.bodyS,
        assert(indentLevel == null || indentSize == null);

  /// Creates a new body medium [AppText] instance.
  const AppText.bodyM(
    this.data, {
    super.key,
    this.color,
    this.indentLevel,
    this.indentSize,
    this.maxLines,
    this.textAlign,
    this.decoration,
    this.shrinkLineHeight,
  })  : type = _AppTypographyType.bodyM,
        assert(indentLevel == null || indentSize == null);

  /// Creates a new body large [AppText] instance.
  const AppText.bodyL(
    this.data, {
    super.key,
    this.color,
    this.indentLevel,
    this.indentSize,
    this.maxLines,
    this.textAlign,
    this.decoration,
    this.shrinkLineHeight,
  })  : type = _AppTypographyType.bodyL,
        assert(indentLevel == null || indentSize == null);

  /// Creates a new body small bold [AppText] instance.
  const AppText.bodySBold(
    this.data, {
    super.key,
    this.color,
    this.indentLevel,
    this.indentSize,
    this.maxLines,
    this.textAlign,
    this.decoration,
    this.shrinkLineHeight,
  })  : type = _AppTypographyType.bodySBold,
        assert(indentLevel == null || indentSize == null);

  /// Creates a new body medium bold [AppText] instance.
  const AppText.bodyMBold(
    this.data, {
    super.key,
    this.color,
    this.indentLevel,
    this.indentSize,
    this.maxLines,
    this.textAlign,
    this.decoration,
    this.shrinkLineHeight,
  })  : type = _AppTypographyType.bodyMBold,
        assert(indentLevel == null || indentSize == null);

  /// Creates a new body large bold [AppText] instance.
  const AppText.bodyLBold(
    this.data, {
    super.key,
    this.color,
    this.indentLevel,
    this.indentSize,
    this.maxLines,
    this.textAlign,
    this.decoration,
    this.shrinkLineHeight,
  })  : type = _AppTypographyType.bodyLBold,
        assert(indentLevel == null || indentSize == null);

  /// The type of typography.
  final _AppTypographyType type;

  /// The text string to display.
  final String data;

  /// The text color.
  final Color? color;

  /// The level of indentation. 1 means indentation by one character.
  final double? indentLevel;

  /// The size of indentation.
  final double? indentSize;

  /// The maximum number of lines. If null, unlimited.
  final int? maxLines;

  /// The alignment of the text.
  final TextAlign? textAlign;

  /// The decoration of the text.
  final TextDecoration? decoration;

  /// Whether to set the line height to the minimum value of 1.0
  /// for displaying text. If true, the line height equals the font size,
  /// resulting in no vertical padding.
  ///
  /// If not specified, the default behavior will adjust
  /// the line height as needed.
  final bool? shrinkLineHeight;

  @override
  Widget build(BuildContext context) {
    final t = AppTypography.of(context);
    final style = switch (type) {
      _AppTypographyType.bodyS => t.bodyS,
      _AppTypographyType.bodyM => t.bodyM,
      _AppTypographyType.bodyL => t.bodyL,
      _AppTypographyType.bodySBold => t.bodySBold,
      _AppTypographyType.bodyMBold => t.bodyMBold,
      _AppTypographyType.bodyLBold => t.bodyLBold,
    };
    return Padding(
      padding: EdgeInsets.only(
        left: indentSize ?? style!.fontSize! * (indentLevel ?? 0),
      ),
      child: Text(
        data,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        textAlign: textAlign,
        style: style?.copyWith(
          color: color,
          decoration: decoration,
          height: (shrinkLineHeight ?? false) ? 1 : null,
        ),
      ),
    );
  }
}
