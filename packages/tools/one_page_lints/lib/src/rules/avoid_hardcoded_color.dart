import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

import '../types.dart';

/// {@template one_page_lints.AvoidHardcodedColor}
/// Reports colors written in code outside the test directories: color
/// constructors, static methods of color classes, and `Colors` constants other
/// than `Colors.transparent`.
///
/// Colors come from the `ColorScheme`, so colors given to a `ColorScheme`
/// constructor or method are allowed.
///
/// ```dart
/// ColoredBox(color: Color(0xFF123456)); // LINT
/// ColoredBox(color: Colors.red); // LINT
/// ColoredBox(color: context.colorScheme.primary); // OK
/// ```
/// {@endtemplate}
class AvoidHardcodedColor extends AnalysisRule {
  /// {@macro one_page_lints.AvoidHardcodedColor}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_hardcoded_color',
    'The color is hardcoded.',
    correctionMessage: 'Try using a color of the ColorScheme.',
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
      ..addInstanceCreationExpression(this, visitor)
      ..addMethodInvocation(this, visitor)
      ..addPrefixedIdentifier(this, visitor)
      ..addPropertyAccess(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    if (isColorType(node.staticType)) {
      _report(node);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final element = node.methodName.element;
    if (element is MethodElement &&
        element.isStatic &&
        isColorType(element.returnType)) {
      final enclosing = element.enclosingElement;
      if (enclosing is InterfaceElement && isColorType(enclosing.thisType)) {
        _report(node);
      }
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    _checkColorsConstant(node, node.identifier);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    _checkColorsConstant(node, node.propertyName);
  }

  void _checkColorsConstant(Expression node, SimpleIdentifier name) {
    if (name.name == 'transparent') {
      return;
    }
    final element = name.element;
    if (isFlutterClass(element?.enclosingElement, 'Colors') &&
        isColorType(node.staticType)) {
      _report(node);
    }
  }

  void _report(Expression node) {
    final inColorScheme = node.thisOrAncestorMatching(
      (ancestor) => switch (ancestor) {
        InstanceCreationExpression() => isFlutterType(
          ancestor.staticType,
          'ColorScheme',
        ),
        MethodInvocation() =>
          isFlutterType(ancestor.realTarget?.staticType, 'ColorScheme') ||
              isFlutterClass(
                ancestor.methodName.element?.enclosingElement,
                'ColorScheme',
              ),
        _ => false,
      },
    );
    if (inColorScheme == null) {
      rule.reportAtNode(node);
    }
  }
}
