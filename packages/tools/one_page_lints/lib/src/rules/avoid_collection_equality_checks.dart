import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

/// {@template one_page_lints.AvoidCollectionEqualityChecks}
/// Reports `==` and `!=` between two collections, and the `hashCode` of a
/// collection or a collection given to `Object.hash`, since they compare or
/// hash whether the collections are the same object, not their elements.
///
/// A collection is an `Iterable`, `List`, `Set`, or `Map`.
///
/// ```dart
/// bool sameTags(List<String> a, List<String> b) => a == b; // LINT
/// int hashTags(List<String> tags) => Object.hash(1, tags); // LINT
///
/// bool sameTags(List<String> a, List<String> b) => listEquals(a, b); // OK
/// int hashTags(List<String> tags) => Object.hash(1, Object.hashAll(tags));
/// ```
/// {@endtemplate}
class AvoidCollectionEqualityChecks extends AnalysisRule {
  /// {@macro one_page_lints.AvoidCollectionEqualityChecks}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_collection_equality_checks',
    'The collection is compared or hashed by identity, not by its elements.',
    correctionMessage:
        'Try using its elements, such as with listEquals or Object.hashAll.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this);
    registry
      ..addBinaryExpression(this, visitor)
      ..addPrefixedIdentifier(this, visitor)
      ..addPropertyAccess(this, visitor)
      ..addMethodInvocation(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitBinaryExpression(BinaryExpression node) {
    final operator = node.operator.type;
    if ((operator == TokenType.EQ_EQ || operator == TokenType.BANG_EQ) &&
        _isCollection(node.leftOperand.staticType) &&
        _isCollection(node.rightOperand.staticType)) {
      rule.reportAtNode(node);
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.identifier.name == 'hashCode' &&
        _isCollection(node.prefix.staticType)) {
      rule.reportAtNode(node);
    }
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.propertyName.name == 'hashCode' &&
        _isCollection(node.realTarget.staticType)) {
      rule.reportAtNode(node);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final enclosing = node.methodName.element?.enclosingElement;
    if (node.methodName.name != 'hash' ||
        enclosing is! ClassElement ||
        !enclosing.thisType.isDartCoreObject) {
      return;
    }
    for (final argument in node.argumentList.arguments) {
      final expression = argument.argumentExpression;
      if (_isCollection(expression.staticType)) {
        rule.reportAtNode(expression);
      }
    }
  }

  static bool _isCollection(DartType? type) =>
      type is InterfaceType &&
      (type.isDartCoreIterable ||
          type.isDartCoreList ||
          type.isDartCoreSet ||
          type.isDartCoreMap);
}
