import 'package:one_page_lints/src/assists/wrap_with_macro_template_document_comment.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../assist_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(WrapWithMacroTemplateDocumentCommentTest);
  });
}

@reflectiveTest
class WrapWithMacroTemplateDocumentCommentTest extends AssistTestBase {
  Future<String?> _assist(String code, String selection) async {
    await assertNoDiagnostics(code);
    return applyCorrection(
      WrapWithMacroTemplateDocumentComment.new,
      selectionOffset: code.indexOf(selection),
    );
  }

  static const _documented = '''
/// A diary.
///
/// One page a day.
class Diary {}
''';

  static const _wrapped = '''
/// {@template test.Diary}
/// A diary.
///
/// One page a day.
/// {@endtemplate}
class Diary {}
''';

  Future<void> test_onComment() async {
    expect(await _assist(_documented, 'One page'), _wrapped);
  }

  Future<void> test_onName() async {
    expect(await _assist(_documented, 'Diary {}'), _wrapped);
  }

  Future<void> test_elsewhere() async {
    expect(await _assist(_documented, '{}'), isNull);
  }

  Future<void> test_withTemplate() async {
    expect(await _assist(_wrapped, 'Diary {}'), isNull);
  }

  Future<void> test_withoutComment() async {
    expect(await _assist('class Diary {}\n', 'Diary'), isNull);
  }

  Future<void> test_kind() async {
    await assertNoDiagnostics('class Diary {}\n');
    final producer = await createCorrection(
      WrapWithMacroTemplateDocumentComment.new,
    );
    expect(
      producer.assistKind?.id,
      'one_page_lints.assist.wrapWithMacroTemplateDocumentComment',
    );
    expect(producer.canBeAppliedAcrossSingleFile, isFalse);
    expect(producer.canBeAppliedAcrossFiles, isFalse);
  }
}
