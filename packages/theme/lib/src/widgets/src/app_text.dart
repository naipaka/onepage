import 'package:flutter/material.dart';

import '../../utils/utils.dart';

/// テキストウィジェットの共通プロパティ。
mixin TextThemeText implements Widget {
  /// 表示する文字列。
  String get data;

  /// 文字色。
  Color? get color;

  /// 字下げする空白数値。
  double? get indent;

  /// 最大行数。nullなら無制限。
  int? get maxLines;

  /// テキストの揃え方。
  TextAlign? get textAlign;

  /// フォントウェイト。
  FontWeight? get fontWeight;

  /// 高さ。
  double? get height;
}

/// [TextTheme.displayLarge] の [Text] ウィジェット。
class DisplayLargeText extends StatelessWidget with TextThemeText {
  /// [DisplayLargeText] インスタンスを作成。
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

/// [TextTheme.displayMedium] の [Text] ウィジェット。
class DisplayMediumText extends StatelessWidget with TextThemeText {
  /// [DisplayMediumText] インスタンスを作成。
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

/// [TextTheme.displaySmall] の [Text] ウィジェット。
class DisplaySmallText extends StatelessWidget with TextThemeText {
  /// [DisplaySmallText] インスタンスを作成。
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

/// [TextTheme.headlineLarge] の [Text] ウィジェット。
class HeadlineLargeText extends StatelessWidget with TextThemeText {
  /// [HeadlineLargeText] インスタンスを作成。
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

/// [TextTheme.headlineMedium] の [Text] ウィジェット。
class HeadlineMediumText extends StatelessWidget with TextThemeText {
  /// [HeadlineMediumText] インスタンスを作成。
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

/// [TextTheme.headlineSmall] の [Text] ウィジェット。
class HeadlineSmallText extends StatelessWidget with TextThemeText {
  /// [HeadlineSmallText] インスタンスを作成。
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

/// [TextTheme.titleLarge] の [Text] ウィジェット。
class TitleLargeText extends StatelessWidget with TextThemeText {
  /// [TitleLargeText] インスタンスを作成。
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

/// [TextTheme.titleMedium] の [Text] ウィジェット。
class TitleMediumText extends StatelessWidget with TextThemeText {
  /// [TitleMediumText] インスタンスを作成。
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

/// [TextTheme.titleSmall] の [Text] ウィジェット。
class TitleSmallText extends StatelessWidget with TextThemeText {
  /// [TitleSmallText] インスタンスを作成。
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

/// [TextTheme.bodyLarge] の [Text] ウィジェット。
class BodyLargeText extends StatelessWidget with TextThemeText {
  /// [BodyLargeText] インスタンスを作成。
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

/// [TextTheme.bodyMedium] の [Text] ウィジェット。
class BodyMediumText extends StatelessWidget with TextThemeText {
  /// [BodyMediumText] インスタンスを作成。
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

/// [TextTheme.bodySmall] の [Text] ウィジェット。
class BodySmallText extends StatelessWidget with TextThemeText {
  /// [BodySmallText] インスタンスを作成。
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

/// [TextTheme.labelLarge] の [Text] ウィジェット。
class LabelLargeText extends StatelessWidget with TextThemeText {
  /// [LabelLargeText] インスタンスを作成。
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

/// [TextTheme.labelMedium] の [Text] ウィジェット。
class LabelMediumText extends StatelessWidget with TextThemeText {
  /// [LabelMediumText] インスタンスを作成。
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

/// [TextTheme.labelSmall] の [Text] ウィジェット。
class LabelSmallText extends StatelessWidget with TextThemeText {
  /// [LabelSmallText] インスタンスを作成。
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
