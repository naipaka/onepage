import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../file_paths.dart';

/// {@template one_page_lints.AvoidIgnoreComments}
/// Reports `// ignore:` and `// ignore_for_file:` comments.
///
/// A diagnostic shows code to change, so fix the code instead of hiding the
/// diagnostic. Generated files are skipped.
///
/// ```dart
/// // ignore: unused_import // LINT
/// import 'dart:async';
/// ```
/// {@endtemplate}
class AvoidIgnoreComments extends AnalysisRule {
  /// {@macro one_page_lints.AvoidIgnoreComments}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_ignore_comments',
    'The comment hides a diagnostic.',
    correctionMessage: 'Try changing the code that the diagnostic reports.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addCompilationUnit(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule, this.context);

  final AnalysisRule rule;

  final RuleContext context;

  /// The comments that the analyzer reads as ignore comments: `ignore:` after
  /// two or more slashes, or `ignore_for_file:` after two, with spaces between.
  static final _ignoreComment = RegExp('^(//+ *ignore|// *ignore_for_file):');

  @override
  void visitCompilationUnit(CompilationUnit node) {
    final unit = context.currentUnit;
    if (unit == null || isGeneratedFile(unit.file, context.package)) {
      return;
    }
    for (Token? token = node.beginToken; token != null; token = token.next) {
      for (
        Token? comment = token.precedingComments;
        comment != null;
        comment = comment.next
      ) {
        if (_ignoreComment.hasMatch(comment.lexeme)) {
          rule.reportAtToken(comment);
        }
      }
      if (token.isEof) {
        return;
      }
    }
  }
}
