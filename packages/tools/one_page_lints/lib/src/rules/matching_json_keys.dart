import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

import '../returned_expressions.dart';

/// {@template one_page_lints.MatchingJsonKeys}
/// Reports a JSON key that only one of `fromJson` and `toJson` uses, since
/// the data that `toJson` writes would not be read back by `fromJson`.
///
/// The keys of `fromJson` are the string literals it uses as an index on its
/// first parameter, and the keys of `toJson` are the string literal keys of
/// the map literal it returns. A class is checked only when it declares both,
/// and `toJson` returns only map literals whose keys are all string literals.
///
/// ```dart
/// class Setting {
///   Setting({required this.isEnabled});
///
///   factory Setting.fromJson(Map<String, dynamic> json) =>
///       Setting(isEnabled: json['is_enabled'] as bool); // LINT
///
///   final bool isEnabled;
///
///   Map<String, dynamic> toJson() => {'isEnabled': isEnabled}; // LINT
/// }
/// ```
/// {@endtemplate}
class MatchingJsonKeys extends AnalysisRule {
  /// {@macro one_page_lints.MatchingJsonKeys}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'matching_json_keys',
    "The key '{0}' is only used in {1}.",
    correctionMessage: 'Try using the same keys in fromJson and toJson.',
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
    final body = node.body;
    if (body is! BlockClassBody) {
      return;
    }
    final fromJson = body.members
        .map(
          (member) => switch (member) {
            ConstructorDeclaration(
              name: Token(lexeme: 'fromJson'),
              :final parameters,
            ) =>
              (member, parameters),
            MethodDeclaration(
              name: Token(lexeme: 'fromJson'),
              isStatic: true,
              :final parameters,
            ) =>
              (member, parameters),
            _ => null,
          },
        )
        .nonNulls
        .firstOrNull;
    final toJson = body.members
        .whereType<MethodDeclaration>()
        .where((method) => !method.isStatic && method.name.lexeme == 'toJson')
        .firstOrNull;
    if (fromJson == null || toJson == null) {
      return;
    }
    final readKeys = _readKeys(fromJson.$1, fromJson.$2);
    final writtenKeys = _writtenKeys(toJson);
    if (readKeys == null || writtenKeys == null) {
      return;
    }
    _reportUnmatched(readKeys, writtenKeys, 'fromJson');
    _reportUnmatched(writtenKeys, readKeys, 'toJson');
  }

  void _reportUnmatched(
    List<SimpleStringLiteral> keys,
    List<SimpleStringLiteral> otherKeys,
    String member,
  ) {
    final otherValues = {for (final key in otherKeys) key.value};
    for (final key in keys) {
      if (!otherValues.contains(key.value)) {
        rule.reportAtNode(key, arguments: [key.value, member]);
      }
    }
  }

  /// The string literals that [fromJson] uses as an index on its first
  /// parameter, or null when it has no parameter or uses no such index.
  static List<SimpleStringLiteral>? _readKeys(
    ClassMember fromJson,
    FormalParameterList? parameters,
  ) {
    final json = parameters?.parameters.firstOrNull?.declaredFragment?.element;
    if (json == null) {
      return null;
    }
    final collector = _IndexCollector(json);
    fromJson.accept(collector);
    return collector.keys.isEmpty ? null : collector.keys;
  }

  /// The keys of the map literals that [toJson] returns, or null when it
  /// returns anything else or a key that is not a string literal.
  static List<SimpleStringLiteral>? _writtenKeys(MethodDeclaration toJson) {
    final keys = <SimpleStringLiteral>[];
    final returned = returnedExpressions(toJson.body);
    if (returned.isEmpty) {
      return null;
    }
    for (final expression in returned) {
      if (expression is! SetOrMapLiteral) {
        return null;
      }
      for (final element in expression.elements) {
        if (element case MapLiteralEntry(:final SimpleStringLiteral key)) {
          keys.add(key);
        } else {
          return null;
        }
      }
    }
    return keys;
  }
}

class _IndexCollector extends RecursiveAstVisitor<void> {
  new(this.json);

  final FormalParameterElement json;

  final keys = <SimpleStringLiteral>[];

  @override
  void visitIndexExpression(IndexExpression node) {
    if (node.target case SimpleIdentifier(:final element)
        when element == json) {
      if (node.index case final SimpleStringLiteral key) {
        keys.add(key);
      }
    }
    super.visitIndexExpression(node);
  }
}
