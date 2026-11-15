import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

import 'macro_names.dart';

/// {@template one_page_lints.AddMacroDocumentComment}
/// Adds a `{@macro}` documentation comment to the constructor or method whose
/// signature the cursor is on, when it has no documentation comment.
///
/// A constructor refers to the template of its type, and a method refers to
/// the template named after its type and itself.
///
/// ```dart
/// class DiaryPage extends StatelessWidget {
///   /// {@macro diary.DiaryPage}
///   const DiaryPage({super.key});
/// }
/// ```
/// {@endtemplate}
class AddMacroDocumentComment extends ResolvedCorrectionProducer {
  /// {@macro one_page_lints.AddMacroDocumentComment}
  new({required super.context});

  static const _kind = AssistKind(
    'one_page_lints.assist.addMacroDocumentComment',
    DartFixKindPriority.standard,
    'Add a macro documentation comment',
  );

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  AssistKind get assistKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final member = node.thisOrAncestorOfType<ClassMember>();
    final (body, memberName) = switch (member) {
      ConstructorDeclaration(:final body) => (body, null),
      MethodDeclaration(:final body, :final name) => (body, name.lexeme),
      _ => (null, null),
    };
    final declaration = enclosingTypeDeclaration(node);
    final packageName = packageNameOfUnit(unitResult);
    if (member == null ||
        body == null ||
        declaration == null ||
        packageName == null ||
        member.documentationComment != null ||
        selectionOffset >= body.offset) {
      return;
    }
    final macroName = [
      packageName,
      declaration.name.lexeme,
      ?memberName,
    ].join('.');
    final lineStart = unitResult.lineInfo.getOffsetOfLine(
      unitResult.lineInfo.getLocation(member.offset).lineNumber - 1,
    );
    final indent = unitResult.content.substring(lineStart, member.offset);
    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleInsertion(
        member.offset,
        '/// {@macro $macroName}\n$indent',
      );
    });
  }
}
