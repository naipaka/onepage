import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

import '../types.dart';

/// {@template one_page_lints.AvoidSingleChild}
/// Reports a widget for many children, such as `Column` or `SliverList`, given
/// a list that always has one child at most.
///
/// A `for` element or a spread can add more than one child, so they are
/// allowed.
///
/// ```dart
/// Column(children: [Text(title)]); // LINT
/// Column(children: [for (final title in titles) Text(title)]); // OK
/// ```
/// {@endtemplate}
class AvoidSingleChild extends AnalysisRule {
  /// {@macro one_page_lints.AvoidSingleChild}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_single_child',
    'A widget for many children has one child at most.',
    correctionMessage:
        'Try using a widget for a single child, or adding the other '
        'children.',
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

  static const _widgets = {
    'Column',
    'Row',
    'Flex',
    'Wrap',
    'Stack',
    'ListView',
    'SliverList',
    'SliverMainAxisGroup',
    'SliverCrossAxisGroup',
  };

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (!_widgets.any((name) => isFlutterType(node.staticType, name))) {
      return;
    }
    for (final argument
        in node.argumentList.arguments.whereType<NamedArgument>()) {
      if (argument.name.lexeme case 'children' || 'slivers') {
        if (argument.argumentExpression case ListLiteral(:final elements)
            when elements.length == 1 &&
                !_canHaveManyChildren(elements.single)) {
          rule.reportAtNode(node.constructorName);
        }
      }
    }
  }

  bool _canHaveManyChildren(CollectionElement element) => switch (element) {
    ForElement() => true,
    SpreadElement(expression: ListLiteral(:final elements)) =>
      elements.length > 1 || elements.any(_canHaveManyChildren),
    SpreadElement() => true,
    IfElement(:final thenElement, :final elseElement) =>
      _canHaveManyChildren(thenElement) ||
          (elseElement != null && _canHaveManyChildren(elseElement)),
    _ => false,
  };
}
