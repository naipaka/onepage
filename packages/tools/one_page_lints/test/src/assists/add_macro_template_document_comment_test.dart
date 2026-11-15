import 'package:one_page_lints/src/assists/add_macro_template_document_comment.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../assist_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AddMacroTemplateDocumentCommentTest);
  });
}

@reflectiveTest
class AddMacroTemplateDocumentCommentTest extends AssistTestBase {
  Future<String?> _assist(String code, String selection) async {
    await assertNoDiagnostics(code);
    return applyCorrection(
      AddMacroTemplateDocumentComment.new,
      selectionOffset: code.indexOf(selection),
    );
  }

  Future<void> test_class() async {
    final assisted = await _assist('class Diary {}\n', 'Diary');
    expect(
      assisted,
      [
        '/// {@template test.Diary}',
        '/// ',
        '/// {@endtemplate}',
        'class Diary {}',
        '',
      ].join('\n'),
    );
  }

  Future<void> test_annotatedClass() async {
    final assisted = await _assist(
      '@Deprecated("")\nclass Diary {}\n',
      'Diary',
    );
    expect(
      assisted,
      [
        '/// {@template test.Diary}',
        '/// ',
        '/// {@endtemplate}',
        '@Deprecated("")',
        'class Diary {}',
        '',
      ].join('\n'),
    );
  }

  Future<void> test_enum() async {
    final assisted = await _assist('enum Mood { good }\n', 'Mood');
    expect(assisted, startsWith('/// {@template test.Mood}\n'));
  }

  Future<void> test_mixin() async {
    final assisted = await _assist('mixin Writable {}\n', 'Writable');
    expect(assisted, startsWith('/// {@template test.Writable}\n'));
  }

  Future<void> test_extensionType() async {
    final assisted = await _assist(
      'extension type Page(int number) {}\n',
      'Page',
    );
    expect(assisted, startsWith('/// {@template test.Page}\n'));
  }

  Future<void> test_typeAlias() async {
    final assisted = await _assist('typedef Pages = List<int>;\n', 'Pages');
    expect(assisted, startsWith('/// {@template test.Pages}\n'));
  }

  Future<void> test_outsideName() async {
    final assisted = await _assist('class Diary {}\n', '{}');
    expect(assisted, isNull);
  }

  Future<void> test_documented() async {
    final assisted = await _assist('/// A diary.\nclass Diary {}\n', 'Diary');
    expect(assisted, isNull);
  }

  Future<void> test_extension() async {
    final assisted = await _assist('extension Pages on int {}\n', 'Pages');
    expect(assisted, isNull);
  }

  Future<void> test_testDirectory() async {
    final path = testDirectoryFile('diary_test.dart');
    newFile(path, 'class Diary {}\n');
    await assertNoDiagnosticsInFile(path);
    final assisted = await applyCorrection(
      AddMacroTemplateDocumentComment.new,
      selectionOffset: 6,
    );
    expect(assisted, startsWith('/// {@template test.Diary}\n'));
  }

  Future<void> test_withoutPubspec() async {
    final path = convertPath('$workspaceRootPath/notes/diary.dart');
    newFile(path, 'class Diary {}\n');
    await assertNoDiagnosticsInFile(path);
    final assisted = await applyCorrection(
      AddMacroTemplateDocumentComment.new,
      selectionOffset: 6,
    );
    expect(assisted, isNull);
  }

  Future<void> test_kind() async {
    await assertNoDiagnostics('class Diary {}\n');
    final producer = await createCorrection(
      AddMacroTemplateDocumentComment.new,
    );
    expect(
      producer.assistKind?.id,
      'one_page_lints.assist.addMacroTemplateDocumentComment',
    );
    expect(producer.canBeAppliedAcrossSingleFile, isFalse);
    expect(producer.canBeAppliedAcrossFiles, isFalse);
  }
}
