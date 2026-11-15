import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';

import '../returned_expressions.dart';
import '../types.dart';

/// {@template one_page_lints.PreferWidgetClass}
/// Reports a function, a method, or a getter that returns a widget.
///
/// A widget class rebuilds on its own and can be `const`. A method that
/// overrides a member of another package, such as `build`, and a lookup of an
/// inherited widget, such as `of`, are allowed. Test directories are skipped,
/// since tests build the widgets they pump in functions.
///
/// ```dart
/// Widget _buildTitle() => const Text('Title'); // LINT
///
/// class _Title extends StatelessWidget { // OK
///   const _Title();
///
///   @override
///   Widget build(BuildContext context) => const Text('Title');
/// }
/// ```
/// {@endtemplate}
class PreferWidgetClass extends AnalysisRule {
  /// {@macro one_page_lints.PreferWidgetClass}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'prefer_widget_class',
    'A function returns a widget.',
    correctionMessage: 'Try making a widget class instead.',
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
      ..addFunctionDeclaration(this, visitor)
      ..addMethodDeclaration(this, visitor);
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final function = node.functionExpression;
    if (_returnsWidget(
      declaredReturnType: node.returnType,
      returnType: node.declaredFragment?.element.returnType,
      body: function.body,
    )) {
      rule.reportAtToken(node.name);
    }
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final element = node.declaredFragment?.element;
    if (element == null ||
        element.isAbstract ||
        _overridesOtherPackage(element)) {
      return;
    }
    if (_returnsWidget(
      declaredReturnType: node.returnType,
      returnType: element.returnType,
      body: node.body,
    )) {
      rule.reportAtToken(node.name);
    }
  }

  bool _returnsWidget({
    required TypeAnnotation? declaredReturnType,
    required DartType? returnType,
    required FunctionBody body,
  }) {
    if (body is EmptyFunctionBody || body is NativeFunctionBody) {
      return false;
    }
    if (declaredReturnType != null) {
      return _isBuiltWidget(returnType);
    }
    final returned = returnedExpressions(
      body,
    ).where((expression) => expression is! NullLiteral);
    return returned.isNotEmpty &&
        returned.every((expression) => _isBuiltWidget(expression.staticType));
  }

  /// Whether [type] is a widget that a function builds. An inherited widget
  /// is found in the tree by a lookup such as `of`.
  bool _isBuiltWidget(DartType? type) =>
      isWidgetType(type) && !isFlutterSubtype(type, 'InheritedWidget');

  bool _overridesOtherPackage(ExecutableElement element) {
    final enclosing = element.enclosingElement;
    final name = element.name;
    if (enclosing is! InterfaceElement || name == null) {
      return false;
    }
    final package = packageNameOf(element.library.uri);
    final overridden = enclosing.getOverridden(
      Name.forLibrary(element.library, element.lookupName ?? name),
    );
    return overridden?.any(
          (member) =>
              package == null || packageNameOf(member.library.uri) != package,
        ) ??
        false;
  }
}
