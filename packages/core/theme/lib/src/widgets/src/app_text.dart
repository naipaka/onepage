import 'package:flutter/material.dart';

import '../../utils/utils.dart';

/// Common properties for text widgets.
mixin TextThemeText implements Widget {
  /// The string to display.
  String get data;

  /// The color of the text.
  Color? get color;

  /// The number of spaces to indent.
  double? get indent;

  /// The maximum number of lines. If null, unlimited.
  int? get maxLines;

  /// The alignment of the text.
  TextAlign? get textAlign;

  /// The font weight.
  FontWeight? get fontWeight;

  /// The height of the text.
  double? get height;
}

/// {@template theme.DisplayLargeText}
/// [TextTheme.displayLarge] text widget.
/// {@endtemplate}
class DisplayLargeText extends StatelessWidget with TextThemeText {
  /// {@macro theme.DisplayLargeText}
  const DisplayLargeText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.displayLarge!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.DisplayMediumText}
/// [TextTheme.displayMedium] text widget.
/// {@endtemplate}
class DisplayMediumText extends StatelessWidget with TextThemeText {
  /// {@macro theme.DisplayMediumText}
  const DisplayMediumText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.displayMedium!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.DisplaySmallText}
/// [TextTheme.displaySmall] text widget.
/// {@endtemplate}
class DisplaySmallText extends StatelessWidget with TextThemeText {
  /// {@macro theme.DisplaySmallText}
  const DisplaySmallText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.displaySmall!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.HeadlineLargeText}
/// [TextTheme.headlineLarge] text widget.
/// {@endtemplate}
class HeadlineLargeText extends StatelessWidget with TextThemeText {
  /// {@macro theme.HeadlineLargeText}
  const HeadlineLargeText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.headlineLarge!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.HeadlineMediumText}
/// [TextTheme.headlineMedium] text widget.
/// {@endtemplate}
class HeadlineMediumText extends StatelessWidget with TextThemeText {
  /// {@macro theme.HeadlineMediumText}
  const HeadlineMediumText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.headlineMedium!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.HeadlineSmallText}
/// [TextTheme.headlineSmall] text widget.
/// {@endtemplate}
class HeadlineSmallText extends StatelessWidget with TextThemeText {
  /// {@macro theme.HeadlineSmallText}
  const HeadlineSmallText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.headlineSmall!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.TitleLargeText}
/// [TextTheme.titleLarge] text widget.
/// {@endtemplate}
class TitleLargeText extends StatelessWidget with TextThemeText {
  /// {@macro theme.TitleLargeText}
  const TitleLargeText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.titleLarge!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.TitleMediumText}
/// [TextTheme.titleMedium] text widget.
/// {@endtemplate}
class TitleMediumText extends StatelessWidget with TextThemeText {
  /// {@macro theme.TitleMediumText}
  const TitleMediumText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.titleMedium!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.TitleSmallText}
/// [TextTheme.titleSmall] text widget.
/// {@endtemplate}
class TitleSmallText extends StatelessWidget with TextThemeText {
  /// {@macro theme.TitleSmallText}
  const TitleSmallText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.titleSmall!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.BodyLargeText}
/// [TextTheme.bodyLarge] text widget.
/// {@endtemplate}
class BodyLargeText extends StatelessWidget with TextThemeText {
  /// {@macro theme.BodyLargeText}
  const BodyLargeText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.bodyLarge!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.BodyMediumText}
/// [TextTheme.bodyMedium] text widget.
/// {@endtemplate}
class BodyMediumText extends StatelessWidget with TextThemeText {
  /// {@macro theme.BodyMediumText}
  const BodyMediumText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.bodyMedium!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.BodySmallText}
/// [TextTheme.bodySmall] text widget.
/// {@endtemplate}
class BodySmallText extends StatelessWidget with TextThemeText {
  /// {@macro theme.BodySmallText}
  const BodySmallText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.bodySmall!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.LabelLargeText}
/// [TextTheme.labelLarge] text widget.
/// {@endtemplate}
class LabelLargeText extends StatelessWidget with TextThemeText {
  /// {@macro theme.LabelLargeText}
  const LabelLargeText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.labelLarge!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.LabelMediumText}
/// [TextTheme.labelMedium] text widget.
/// {@endtemplate}
class LabelMediumText extends StatelessWidget with TextThemeText {
  /// {@macro theme.LabelMediumText}
  const LabelMediumText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.labelMedium!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

/// {@template theme.LabelSmallText}
/// [TextTheme.labelSmall] text widget.
/// {@endtemplate}
class LabelSmallText extends StatelessWidget with TextThemeText {
  /// {@macro theme.LabelSmallText}
  const LabelSmallText(
    this.data, {
    super.key,
    this.color,
    this.indent,
    this.maxLines,
    this.textAlign,
    this.fontWeight,
    this.height,
  });

  @override
  final String data;

  @override
  final Color? color;

  @override
  final double? indent;

  @override
  final int? maxLines;

  @override
  final TextAlign? textAlign;

  @override
  final FontWeight? fontWeight;

  @override
  final double? height;

  @override
  Widget build(BuildContext context) {
    return _TextThemeText(
      data,
      color: color,
      indent: indent,
      maxLines: maxLines,
      textAlign: textAlign,
      style: context.textTheme.labelSmall!.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
      ),
    );
  }
}

class _TextThemeText extends StatelessWidget {
  const _TextThemeText(
    this.data, {
    required this.color,
    required this.indent,
    required this.maxLines,
    required this.textAlign,
    required this.style,
  });

  final String data;
  final Color? color;
  final double? indent;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent ?? 0),
      child: Text(
        data,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
