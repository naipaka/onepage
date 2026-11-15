import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../types.dart';

/// {@template one_page_lints.AvoidShrinkWrapInListView}
/// Reports `shrinkWrap` of a `ListView` inside a `ListView`, `Column`, or
/// `Row`.
///
/// A shrink-wrapping list lays out every child at once. Slivers in a
/// `CustomScrollView` keep the inner list lazy.
///
/// ```dart
/// Column(
///   children: [
///     ListView(shrinkWrap: true, children: items), // LINT
///   ],
/// );
/// ```
/// {@endtemplate}
class AvoidShrinkWrapInListView extends AnalysisRule {
  /// {@macro one_page_lints.AvoidShrinkWrapInListView}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_shrink_wrap_in_list_view',
    'A ListView in a ListView, Column, or Row shrink-wraps its children.',
    correctionMessage:
        'Try using slivers in a CustomScrollView instead. A shrink-wrapping '
        'list fits only where the children are few, such as in a dialog.',
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
    if (!isFlutterType(node.staticType, 'ListView')) {
      return;
    }
    final shrinkWrap = node.argumentList.arguments
        .whereType<NamedArgument>()
        .where((argument) => argument.name.lexeme == 'shrinkWrap')
        .firstOrNull;
    if (shrinkWrap == null) {
      return;
    }
    if (shrinkWrap.argumentExpression case BooleanLiteral(value: false)) {
      return;
    }
    final parentList = node.parent?.thisOrAncestorMatching(
      (ancestor) =>
          ancestor is InstanceCreationExpression &&
          const {
            'ListView',
            'Column',
            'Row',
          }.any((name) => isFlutterType(ancestor.staticType, name)),
    );
    if (parentList != null) {
      rule.reportAtNode(shrinkWrap);
    }
  }
}
