import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';

/// {@template one_page_lints.PreferSpaceBetweenElements}
/// Reports a class member with no blank line after the member before it, when
/// the two are a field and a constructor, or a field or a constructor and the
/// `build` method.
///
/// ```dart
/// class Greeting extends StatelessWidget {
///   const Greeting({super.key});
///   @override // LINT
///   Widget build(BuildContext context) => const Text('Hello');
/// }
/// ```
/// {@endtemplate}
class PreferSpaceBetweenElements extends AnalysisRule {
  /// {@macro one_page_lints.PreferSpaceBetweenElements}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'prefer_space_between_elements',
    'There is no blank line between the fields, the constructors, and the '
        'build method.',
    correctionMessage: 'Try adding a blank line before this member.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addClassDeclaration(this, _Visitor(this, context));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule, this.context);

  final AnalysisRule rule;

  final RuleContext context;

  static final _blankLine = RegExp(r'\n[ \t]*\r?\n');

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final body = node.body;
    final content = context.currentUnit?.content;
    if (body is! BlockClassBody || content == null) {
      return;
    }
    final members = body.members;
    for (var i = 1; i < members.length; i++) {
      final previous = members[i - 1];
      final member = members[i];
      if (_needsBlankLine(previous, member) &&
          !_blankLine.hasMatch(
            content.substring(previous.end, _startOf(member)),
          )) {
        rule.reportAtNode(member);
      }
    }
  }

  bool _needsBlankLine(ClassMember previous, ClassMember member) =>
      switch ((previous, member)) {
        (FieldDeclaration(), ConstructorDeclaration()) => true,
        (ConstructorDeclaration(), FieldDeclaration()) => true,
        (
          FieldDeclaration() || ConstructorDeclaration(),
          MethodDeclaration(:final name),
        ) =>
          name.lexeme == 'build',
        _ => false,
      };

  /// The offset of [member] including the comments above it.
  int _startOf(ClassMember member) =>
      member.beginToken.precedingComments?.offset ?? member.offset;
}
