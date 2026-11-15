import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

import 'macro_names.dart';

/// {@template one_page_lints.WrapWithMacroTemplateDocumentComment}
/// Wraps the documentation comment of a type declaration in a `{@template}`,
/// when the cursor is on the comment or the name and the comment has no
/// template.
///
/// ```dart
/// /// {@template diary.DiaryPage}
/// /// The page of one diary.
/// /// {@endtemplate}
/// class DiaryPage extends StatelessWidget {}
/// ```
/// {@endtemplate}
class WrapWithMacroTemplateDocumentComment extends ResolvedCorrectionProducer {
  /// {@macro one_page_lints.WrapWithMacroTemplateDocumentComment}
  new({required super.context});

  static const _kind = AssistKind(
    'one_page_lints.assist.wrapWithMacroTemplateDocumentComment',
    DartFixKindPriority.standard,
    'Wrap with a macro template documentation comment',
  );

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  AssistKind get assistKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final declaration = enclosingTypeDeclaration(node);
    final comment = declaration?.node.documentationComment;
    final packageName = packageNameOfUnit(unitResult);
    if (declaration == null || comment == null || packageName == null) {
      return;
    }
    final onComment =
        comment.offset <= selectionOffset && selectionOffset <= comment.end;
    final onName =
        declaration.name.offset <= selectionOffset &&
        selectionOffset <= declaration.name.end;
    final hasTemplate = comment.tokens.any(
      (token) => token.lexeme.contains('{@template '),
    );
    if ((!onComment && !onName) || hasTemplate) {
      return;
    }
    final macroName = '$packageName.${declaration.name.lexeme}';
    await builder.addDartFileEdit(file, (builder) {
      builder
        ..addSimpleInsertion(comment.offset, '/// {@template $macroName}\n')
        ..addSimpleInsertion(comment.end, '\n/// {@endtemplate}');
    });
  }
}
