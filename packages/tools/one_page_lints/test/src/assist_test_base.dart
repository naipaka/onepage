import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/error/error.dart';

import 'rule_test_base.dart';

/// {@template one_page_lints.AssistTestBase}
/// A test of an assist, which needs no lint rule.
///
/// The analysis rule test requires a rule, so this test sets one that reports
/// nothing.
/// {@endtemplate}
abstract class AssistTestBase extends RuleTestBase {
  @override
  void setUp() {
    rule = _NoLint();
    super.setUp();
  }
}

class _NoLint extends AnalysisRule {
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  static const code = LintCode('no_lint', 'Never reported.');

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {}
}
