import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

import 'macro_names.dart';

/// {@template one_page_lints.AddMacroTemplateDocumentComment}
/// Adds a `{@template}` documentation comment to the type declaration whose
/// name the cursor is on, when it has no documentation comment.
///
/// ```dart
/// /// {@template diary.DiaryPage}
/// ///
/// /// {@endtemplate}
/// class DiaryPage extends StatelessWidget {}
/// ```
/// {@endtemplate}
class AddMacroTemplateDocumentComment extends ResolvedCorrectionProducer {
  /// {@macro one_page_lints.AddMacroTemplateDocumentComment}
  new({required super.context});

  static const _kind = AssistKind(
    'one_page_lints.assist.addMacroTemplateDocumentComment',
    DartFixKindPriority.standard,
    'Add a macro template documentation comment',
  );

  @override
  CorrectionApplicability get applicability => .singleLocation;

  @override
  AssistKind get assistKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final declaration = enclosingTypeDeclaration(node);
    final packageName = packageNameOfUnit(unitResult);
    if (declaration == null ||
        packageName == null ||
        declaration.node.documentationComment != null ||
        selectionOffset < declaration.name.offset ||
        selectionOffset > declaration.name.end) {
      return;
    }
    final macroName = '$packageName.${declaration.name.lexeme}';
    await builder.addDartFileEdit(file, (builder) {
      builder.addInsertion(declaration.node.offset, (builder) {
        builder
          ..writeln('/// {@template $macroName}')
          ..write('/// ')
          ..selectHere()
          ..writeln()
          ..writeln('/// {@endtemplate}');
      });
    });
  }
}
