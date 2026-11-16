import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template one_page_lints.AvoidOptionalParametersInImmutableClasses}
/// Reports an optional parameter of a constructor of an `@immutable` class,
/// since a caller that leaves it out can't be told from one that decided on
/// its default value.
///
/// ```dart
/// @immutable
/// class Setting {
///   const Setting({required this.hour, this.note}); // LINT
///
///   final int hour;
///   final String? note;
/// }
///
/// @immutable
/// class Setting {
///   const Setting({required this.hour, required this.note}); // OK
///
///   final int hour;
///   final String? note;
/// }
/// ```
/// {@endtemplate}
class AvoidOptionalParametersInImmutableClasses extends AnalysisRule {
  /// {@macro one_page_lints.AvoidOptionalParametersInImmutableClasses}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_optional_parameters_in_immutable_classes',
    "The parameter '{0}' of an @immutable class is optional.",
    correctionMessage: "Try making '{0}' required.",
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
    final element = node.declaredFragment?.element;
    if (element == null || !element.metadata.hasImmutable) {
      return;
    }
    for (final constructor in element.constructors) {
      for (final parameter in constructor.formalParameters) {
        final offset = parameter.firstFragment.nameOffset;
        if (parameter.isOptional && offset != null) {
          rule.reportAtOffset(
            offset,
            parameter.displayName.length,
            arguments: [parameter.displayName],
          );
        }
      }
    }
  }
}
