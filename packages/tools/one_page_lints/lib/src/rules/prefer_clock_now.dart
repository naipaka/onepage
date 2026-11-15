import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template one_page_lints.PreferClockNow}
/// Reports `DateTime.now()` and `DateTime.timestamp()`.
///
/// Tests can fix the time read with `clock.now()` of package:clock.
///
/// ```dart
/// final now = DateTime.now(); // LINT
/// final now = clock.now(); // OK
/// ```
/// {@endtemplate}
class PreferClockNow extends AnalysisRule {
  /// {@macro one_page_lints.PreferClockNow}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'prefer_clock_now',
    'The current time is read from DateTime, which tests cannot fix.',
    correctionMessage: "Try using 'clock.now()' of package:clock.",
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addInstanceCreationExpression(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (isDateTimeNow(node)) {
      rule.reportAtNode(node);
    }
  }
}

/// Whether [node] is `DateTime.now()` or `DateTime.timestamp()`.
bool isDateTimeNow(InstanceCreationExpression node) {
  final constructor = node.constructorName.element;
  final dateTime = constructor?.enclosingElement;
  return dateTime != null &&
      dateTime.name == 'DateTime' &&
      dateTime.library.isDartCore &&
      const {'now', 'timestamp'}.contains(constructor?.name);
}
