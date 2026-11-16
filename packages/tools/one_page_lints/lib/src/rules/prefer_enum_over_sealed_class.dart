import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

/// {@template one_page_lints.PreferEnumOverSealedClass}
/// Reports a sealed class whose direct subtypes hold no data, since an enum
/// expresses the same fixed set of values.
///
/// The class is reported when all of its direct subtypes are classes that
/// have no instance fields, no type parameters, no subclasses, and no other
/// supertypes, since an enum value cannot have any of them on its own.
///
/// ```dart
/// sealed class ExportFormat {} // LINT
/// class Pdf extends ExportFormat {}
/// class Csv extends ExportFormat {}
///
/// sealed class LoadState {} // OK
/// class Loading extends LoadState {}
/// class Failed extends LoadState {
///   Failed(this.error);
///   final Object error;
/// }
/// ```
/// {@endtemplate}
class PreferEnumOverSealedClass extends AnalysisRule {
  /// {@macro one_page_lints.PreferEnumOverSealedClass}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'prefer_enum_over_sealed_class',
    'The subtypes of the sealed class hold no data.',
    correctionMessage: 'Try using an enum instead.',
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
    if (element == null ||
        !element.isSealed ||
        element.typeParameters.isNotEmpty) {
      return;
    }
    final library = element.library;
    final otherSubtypes = <InterfaceElement>[
      ...library.mixins,
      ...library.enums,
      ...library.extensionTypes,
    ].where((type) => _isDirectSubtype(type, element));
    if (otherSubtypes.isNotEmpty) {
      return;
    }
    final subclasses = library.classes
        .where((type) => _isDirectSubtype(type, element))
        .toList();
    if (subclasses.isEmpty ||
        !subclasses.every((type) => _holdsNoData(type, element, library))) {
      return;
    }
    rule.reportAtToken(node.namePart.typeName);
  }

  static bool _isDirectSubtype(InterfaceElement type, ClassElement sealed) => [
    type.supertype,
    ...type.interfaces,
    ...type.mixins,
    if (type is MixinElement) ...type.superclassConstraints,
  ].any((supertype) => supertype?.element == sealed);

  /// Whether [type] could be a value of an enum: it has no instance fields,
  /// no type parameters, no subclasses in [library], and no supertype other
  /// than [sealed].
  static bool _holdsNoData(
    ClassElement type,
    ClassElement sealed,
    LibraryElement library,
  ) {
    final supertype = type.supertype;
    final onlySealedSupertype = supertype?.element == sealed
        ? type.interfaces.isEmpty
        : (supertype?.isDartCoreObject ?? false) && type.interfaces.length == 1;
    return onlySealedSupertype &&
        type.mixins.isEmpty &&
        type.typeParameters.isEmpty &&
        type.fields.every(
          (field) => field.isStatic || field.isOriginGetterSetter,
        ) &&
        !library.classes.any((other) => _isDirectSubtype(other, type));
  }
}
