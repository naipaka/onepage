import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../types.dart';

/// {@template one_page_lints.AvoidConsecutiveSliverToBoxAdapter}
/// Reports a `SliverToBoxAdapter` that follows another one in a list, also
/// when either is the `sliver` of a widget such as `SliverPadding`.
///
/// One `SliverList.list` lays out the boxes lazily in one sliver.
///
/// ```dart
/// CustomScrollView(
///   slivers: [
///     SliverToBoxAdapter(child: Header()),
///     SliverToBoxAdapter(child: Body()), // LINT
///   ],
/// );
/// ```
/// {@endtemplate}
class AvoidConsecutiveSliverToBoxAdapter extends AnalysisRule {
  /// {@macro one_page_lints.AvoidConsecutiveSliverToBoxAdapter}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_consecutive_sliver_to_box_adapter',
    'SliverToBoxAdapter follows another SliverToBoxAdapter.',
    correctionMessage:
        'Try putting the children in one SliverList.list instead.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addListLiteral(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitListLiteral(ListLiteral node) {
    final elements = node.elements;
    for (var i = 1; i < elements.length; i++) {
      if (_isBoxAdapter(elements[i - 1]) && _isBoxAdapter(elements[i])) {
        rule.reportAtNode(elements[i]);
      }
    }
  }

  bool _isBoxAdapter(CollectionElement element) {
    if (element is! Expression) {
      return false;
    }
    if (isFlutterType(element.staticType, 'SliverToBoxAdapter')) {
      return true;
    }
    if (element is! InstanceCreationExpression) {
      return false;
    }
    return element.argumentList.arguments.whereType<NamedArgument>().any(
      (argument) =>
          argument.name.lexeme == 'sliver' &&
          isFlutterType(
            argument.argumentExpression.staticType,
            'SliverToBoxAdapter',
          ),
    );
  }
}
