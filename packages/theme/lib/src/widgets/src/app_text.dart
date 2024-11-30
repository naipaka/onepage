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

/// [TextTheme.displayLarge] text widget.
class DisplayLargeText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [DisplayLargeText].
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

/// [TextTheme.displayMedium] text widget.
class DisplayMediumText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [DisplayMediumText].
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

/// [TextTheme.displaySmall] text widget.
class DisplaySmallText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [DisplaySmallText].
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

/// [TextTheme.headlineLarge] text widget.
class HeadlineLargeText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [HeadlineLargeText].
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

/// [TextTheme.headlineMedium] text widget.
class HeadlineMediumText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [HeadlineMediumText].
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

/// [TextTheme.headlineSmall] text widget.
class HeadlineSmallText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [HeadlineSmallText].
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

/// [TextTheme.titleLarge] text widget.
class TitleLargeText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [TitleLargeText].
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

/// [TextTheme.titleMedium] text widget.
class TitleMediumText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [TitleMediumText].
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

/// [TextTheme.titleSmall] text widget.
class TitleSmallText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [TitleSmallText].
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

/// [TextTheme.bodyLarge] text widget.
class BodyLargeText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [BodyLargeText].
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

/// [TextTheme.bodyMedium] text widget.
class BodyMediumText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [BodyMediumText].
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

/// [TextTheme.bodySmall] text widget.
class BodySmallText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [BodySmallText].
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

/// [TextTheme.labelLarge] text widget.
class LabelLargeText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [LabelLargeText].
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

/// [TextTheme.labelMedium] text widget.
class LabelMediumText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [LabelMediumText].
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

/// [TextTheme.labelSmall] text widget.
class LabelSmallText extends StatelessWidget with TextThemeText {
  /// Creates an instance of [LabelSmallText].
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
