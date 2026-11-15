import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

import '../types.dart';

/// {@template one_page_lints.PreferDedicatedMediaQueryMethods}
/// Reports `MediaQuery.of` and `MediaQuery.maybeOf`, and `.width` or `.height`
/// of `MediaQuery.sizeOf`.
///
/// The dedicated methods such as `MediaQuery.sizeOf` and `MediaQuery.widthOf`
/// rebuild the widget only when that value changes. `MediaQuery.of(context)`
/// followed by `.copyWith` is allowed, since the copy needs the whole data.
///
/// ```dart
/// MediaQuery.of(context).size; // LINT
/// MediaQuery.sizeOf(context).width; // LINT
/// MediaQuery.widthOf(context); // OK
/// ```
/// {@endtemplate}
class PreferDedicatedMediaQueryMethods extends AnalysisRule {
  /// {@macro one_page_lints.PreferDedicatedMediaQueryMethods}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'prefer_dedicated_media_query_methods',
    'The whole MediaQuery data is read for one of its values.',
    correctionMessage:
        'Try using a dedicated method such as MediaQuery.sizeOf or '
        'MediaQuery.widthOf.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addMethodInvocation(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final element = node.methodName.element;
    if (element is! MethodElement ||
        !element.isStatic ||
        !isFlutterClass(element.enclosingElement, 'MediaQuery')) {
      return;
    }
    final parent = node.parent;
    switch (node.methodName.name) {
      case 'of' || 'maybeOf':
        final isCopied =
            parent is MethodInvocation &&
            parent.target == node &&
            parent.methodName.name == 'copyWith';
        if (!isCopied) {
          rule.reportAtNode(node);
        }
      case 'sizeOf':
        if (parent is PropertyAccess &&
            parent.target == node &&
            const {'width', 'height'}.contains(parent.propertyName.name)) {
          rule.reportAtNode(parent);
        }
    }
  }
}
