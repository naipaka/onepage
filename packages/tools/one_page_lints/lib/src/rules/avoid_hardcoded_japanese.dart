import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template one_page_lints.AvoidHardcodedJapanese}
/// Reports string literals with Japanese text outside the test directories.
///
/// User-facing text belongs in the slang translation files.
///
/// ```dart
/// Text('日記'); // LINT
/// Text(context.t.diary.title); // OK
/// ```
/// {@endtemplate}
class AvoidHardcodedJapanese extends AnalysisRule {
  /// {@macro one_page_lints.AvoidHardcodedJapanese}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_hardcoded_japanese',
    'Japanese text is hardcoded in a string literal.',
    correctionMessage:
        'Try adding the text to the translation files and using the '
        'generated translation.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (context.isInTestDirectory) {
      return;
    }
    final visitor = _Visitor(this);
    registry
      ..addSimpleStringLiteral(this, visitor)
      ..addStringInterpolation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  /// The code point ranges of hiragana and katakana, CJK ideographs, and
  /// half-width katakana.
  static const _japaneseRanges = [
    (0x3040, 0x30FF),
    (0x4E00, 0x9FFF),
    (0xFF66, 0xFF9F),
  ];

  static bool _hasJapanese(String text) => text.runes.any(
    (rune) =>
        _japaneseRanges.any((range) => range.$1 <= rune && rune <= range.$2),
  );

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    if (_hasJapanese(node.value)) {
      rule.reportAtNode(node);
    }
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    final hasJapanese = node.elements.whereType<InterpolationString>().any(
      (element) => _hasJapanese(element.value),
    );
    if (hasJapanese) {
      rule.reportAtNode(node);
    }
  }
}
