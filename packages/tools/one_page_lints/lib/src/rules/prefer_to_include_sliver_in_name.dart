import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../returned_expressions.dart';
import '../types.dart';

/// {@template one_page_lints.PreferToIncludeSliverInName}
/// Reports a class whose `build` method returns a sliver, a widget whose name
/// starts with `Sliver`, when neither the class name nor a named constructor
/// includes "Sliver".
///
/// The name tells the caller to put the widget in a sliver list.
///
/// ```dart
/// class DiaryList extends StatelessWidget { // LINT
///   @override
///   Widget build(BuildContext context) => SliverList.list(children: items);
/// }
/// ```
/// {@endtemplate}
class PreferToIncludeSliverInName extends AnalysisRule {
  /// {@macro one_page_lints.PreferToIncludeSliverInName}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'prefer_to_include_sliver_in_name',
    'The widget returns a sliver, but its name does not include "Sliver".',
    correctionMessage:
        'Try including "Sliver" in the class name or a named constructor.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addClassDeclaration(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final body = node.body;
    if (body is! BlockClassBody) {
      return;
    }
    final build = body.members
        .whereType<MethodDeclaration>()
        .where((method) => method.name.lexeme == 'build')
        .firstOrNull;
    if (build == null) {
      return;
    }
    final returnsSliver = returnedExpressions(build.body).any((expression) {
      final type = expression.staticType;
      return isWidgetType(type) &&
          (type?.element?.name?.startsWith('Sliver') ?? false);
    });
    if (!returnsSliver) {
      return;
    }
    final className = node.namePart.typeName;
    final hasSliverName =
        className.lexeme.contains('Sliver') ||
        body.members.whereType<ConstructorDeclaration>().any(
          (constructor) =>
              constructor.name?.lexeme.toLowerCase().contains('sliver') ??
              false,
        );
    if (!hasSliverName) {
      rule.reportAtToken(className);
    }
  }
}
