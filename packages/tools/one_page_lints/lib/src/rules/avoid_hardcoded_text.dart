import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/workspace/workspace.dart';

import '../file_paths.dart';
import '../types.dart';

/// {@template one_page_lints.AvoidHardcodedText}
/// Reports string literals with letters in `lib`, in any language.
///
/// Text that people read belongs in the slang translation files. A literal is
/// allowed only where it is a value for machines, judged by where it is
/// written and by its shape:
///
/// - Directives, annotations, `assert` messages, `throw` expressions, and
///   `toString` methods.
/// - Arguments of logs (`debugPrint`, simple_logger, and logging), `RegExp`,
///   `DateFormat`, `Key`,
///   `MethodChannel`, the `fromEnvironment` constructors, and the SQL of
///   drift and sqlite3.
/// - URLs, paths, and file names.
/// - Identifiers, such as `'diary_reminder'` or `'photo-recovery'`, except
///   when they are passed straight to a `String` parameter of a widget.
/// - The `static const` fields of a class named `UntranslatedTexts`, for text
///   that stays the same in every language. Each field needs a documentation
///   comment that says why.
///
/// Generated files, the files in a `stub` folder, and the packages in
/// `packages/tools` are skipped.
///
/// ```dart
/// Text('Settings'); // LINT
/// Text(context.t.settings.title); // OK
/// ```
/// {@endtemplate}
class AvoidHardcodedText extends AnalysisRule {
  /// {@macro one_page_lints.AvoidHardcodedText}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'avoid_hardcoded_text',
    'The text is hardcoded in a string literal.',
    correctionMessage:
        'Try adding the text to the translation files. Text that stays the '
        'same in every language goes in a documented static const field of '
        'UntranslatedTexts.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    if (!context.isInLibDir || _isToolsPackage(context.package)) {
      return;
    }
    final visitor = _Visitor(this, context);
    registry
      ..addSimpleStringLiteral(this, visitor)
      ..addStringInterpolation(this, visitor);
  }

  /// Whether [package] is a development tool in `packages/tools`, which the
  /// app does not include.
  static bool _isToolsPackage(WorkspacePackage? package) =>
      package?.root.parent.shortName == 'tools';
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule, this.context);

  final AnalysisRule rule;

  final RuleContext context;

  static final _letter = RegExp(r'\p{L}', unicode: true);

  static final _url = RegExp('^https?://');

  /// A path or a file name: no spaces, and a slash or an extension.
  static final _path = RegExp(r'^\S*(/\S*|\.[A-Za-z0-9]+)$');

  /// An identifier: a lowercase letter, then letters, digits, `_`, `.`, or
  /// `-`.
  static final _identifier = RegExp(r'^[a-z][A-Za-z0-9_.\-]*$');

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    if (node.parent is StringInterpolation) {
      return;
    }
    _check(node, node.value);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    final text = node.elements
        .map(
          (element) => switch (element) {
            InterpolationString(:final value) => value,
            // A placeholder that is a word character, so that a value such
            // as '$name.jpg' keeps the shape of a file name.
            _ => 'x',
          },
        )
        .join();
    final literalText = node.elements
        .whereType<InterpolationString>()
        .map((element) => element.value)
        .join();
    if (!_letter.hasMatch(literalText)) {
      return;
    }
    _check(node, text);
  }

  void _check(StringLiteral node, String text) {
    if (_isSkippedFile() ||
        !_letter.hasMatch(text) ||
        _url.hasMatch(text) ||
        _path.hasMatch(text) ||
        (_identifier.hasMatch(text) && !_isWidgetText(node)) ||
        _isInMachinePlace(node) ||
        _isUntranslatedText(node)) {
      return;
    }
    rule.reportAtNode(node);
  }

  /// Whether the file being analyzed is generated or in a `stub` folder.
  ///
  /// A stub replaces a real implementation with sample data in the language of
  /// each locale, such as diaries for screenshots.
  bool _isSkippedFile() {
    final unit = context.currentUnit;
    if (unit == null) {
      return true;
    }
    return isGeneratedFile(unit.file, context.package) ||
        folderNamesInPackage(unit.file, context.package).contains('stub');
  }

  /// Whether [node] is passed straight to a `String` parameter of a widget.
  bool _isWidgetText(StringLiteral node) {
    final argument = switch (node.parent) {
      final NamedArgument named => named,
      _ => node,
    };
    final creation = argument.parent?.parent;
    return argument.parent is ArgumentList &&
        creation is InstanceCreationExpression &&
        isWidgetType(creation.staticType) &&
        _isString(argument.correspondingParameter?.type);
  }

  /// Whether [type] is `String` or `String?`.
  bool _isString(DartType? type) {
    final element = type?.element;
    return element is InterfaceElement &&
        element.name == 'String' &&
        element.library.isDartCore;
  }

  bool _isInMachinePlace(StringLiteral node) {
    for (var ancestor = node.parent; ancestor != null;) {
      switch (ancestor) {
        case Directive() ||
            Annotation() ||
            AssertStatement() ||
            AssertInitializer() ||
            ThrowExpression():
          return true;
        case MethodDeclaration(:final name) when name.lexeme == 'toString':
          return true;
        case InstanceCreationExpression(:final argumentList)
            when _isMachineConstructor(ancestor) &&
                _contains(argumentList, node):
          return true;
        case MethodInvocation(:final argumentList)
            when _isMachineMethod(ancestor) && _contains(argumentList, node):
          return true;
        case FunctionExpressionInvocation(
              function: Identifier(:final element),
              :final argumentList,
            )
            when _isDebugPrint(element) && _contains(argumentList, node):
          return true;
      }
      ancestor = ancestor.parent;
    }
    return false;
  }

  bool _contains(AstNode container, AstNode node) =>
      container.offset <= node.offset && node.end <= container.end;

  bool _isMachineConstructor(InstanceCreationExpression node) {
    final constructor = node.constructorName.element;
    final type = node.staticType;
    return _isSqlElement(constructor) ||
        _isClass(type, 'RegExp', library: 'dart:core') ||
        constructor?.name == 'fromEnvironment' &&
            (constructor?.library.isDartCore ?? false) ||
        _isClass(type, 'DateFormat', package: 'intl') ||
        isFlutterSubtype(type, 'Key') ||
        isFlutterSubtype(type, 'MethodChannel');
  }

  bool _isMachineMethod(MethodInvocation node) {
    final element = node.methodName.element;
    final enclosing = element?.enclosingElement;
    final library = element?.library;
    final package = library == null ? null : packageNameOf(library.uri);
    return _isSqlElement(element) ||
        const {'simple_logger', 'logging'}.contains(package) ||
        _isDebugPrint(element) ||
        enclosing is InterfaceElement &&
            isFlutterSubtype(enclosing.thisType, 'MethodChannel');
  }

  /// Whether [element] is `debugPrint` of Flutter, a variable that holds a
  /// function.
  bool _isDebugPrint(Element? element) {
    final library = element?.library;
    return element?.name == 'debugPrint' &&
        library != null &&
        packageNameOf(library.uri) == 'flutter';
  }

  /// Whether [element] is from a package that runs SQL.
  bool _isSqlElement(Element? element) {
    final library = element?.library;
    return library != null &&
        const {'drift', 'sqlite3'}.contains(packageNameOf(library.uri));
  }

  bool _isClass(
    DartType? type,
    String name, {
    String? library,
    String? package,
  }) {
    final element = type?.element;
    if (element is! InterfaceElement || element.name != name) {
      return false;
    }
    final uri = element.library.uri;
    return library != null
        ? uri.toString() == library
        : packageNameOf(uri) == package;
  }

  /// Whether [node] is the value of a documented `static const` field of a
  /// class named `UntranslatedTexts`.
  bool _isUntranslatedText(StringLiteral node) {
    final variable = node.parent;
    final field = variable?.parent?.parent;
    final body = field?.parent;
    final declaration = body?.parent;
    return variable is VariableDeclaration &&
        variable.initializer == node &&
        field is FieldDeclaration &&
        field.isStatic &&
        field.fields.isConst &&
        field.documentationComment != null &&
        declaration is ClassDeclaration &&
        declaration.namePart.typeName.lexeme == 'UntranslatedTexts';
  }
}
