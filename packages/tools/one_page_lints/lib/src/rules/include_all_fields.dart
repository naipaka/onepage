import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

/// {@template one_page_lints.IncludeAllFields}
/// Reports a field of an `@immutable` class that one of its `==`,
/// `hashCode`, `toString`, `copyWith`, and `toJson` doesn't use, since that
/// member would ignore the field.
///
/// Only the members that the class declares are checked. A field counts as
/// used when the member refers to it, as `x`, `this.x`, or `other.x`.
///
/// ```dart
/// @immutable
/// class Setting {
///   const Setting({required this.hour, required this.isEnabled});
///
///   final int hour;
///   final bool isEnabled;
///
///   @override
///   bool operator ==(Object other) => // LINT
///       other is Setting && other.hour == hour;
///
///   @override
///   int get hashCode => Object.hash(hour, isEnabled); // OK
/// }
/// ```
/// {@endtemplate}
class IncludeAllFields extends AnalysisRule {
  /// {@macro one_page_lints.IncludeAllFields}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'include_all_fields',
    "The field '{0}' isn't included in {1}.",
    correctionMessage: "Try including '{0}' in {1}.",
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

const _memberNames = {'==', 'hashCode', 'toString', 'copyWith', 'toJson'};

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final element = node.declaredFragment?.element;
    final body = node.body;
    if (element == null ||
        !element.metadata.hasImmutable ||
        body is! BlockClassBody) {
      return;
    }
    final fields = element.fields
        .where((field) => !field.isStatic && !field.isOriginGetterSetter)
        .toList();
    for (final member in body.members.whereType<MethodDeclaration>()) {
      final name = member.name.lexeme;
      if (member.isStatic || !_memberNames.contains(name)) {
        continue;
      }
      final collector = _FieldCollector();
      member.body.accept(collector);
      for (final field in fields) {
        if (!collector.fields.contains(field)) {
          rule.reportAtToken(member.name, arguments: [field.displayName, name]);
        }
      }
    }
  }
}

class _FieldCollector extends RecursiveAstVisitor<void> {
  final fields = <FieldElement>{};

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.element case PropertyAccessorElement(
      :final FieldElement variable,
    )) {
      fields.add(variable);
    }
    super.visitSimpleIdentifier(node);
  }
}
