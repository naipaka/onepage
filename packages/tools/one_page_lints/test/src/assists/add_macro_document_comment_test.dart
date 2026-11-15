import 'package:one_page_lints/src/assists/add_macro_document_comment.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../assist_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AddMacroDocumentCommentTest);
  });
}

@reflectiveTest
class AddMacroDocumentCommentTest extends AssistTestBase {
  Future<String?> _assist(String code, String selection) async {
    await assertNoDiagnostics(code);
    return applyCorrection(
      AddMacroDocumentComment.new,
      selectionOffset: code.indexOf(selection),
    );
  }

  Future<void> test_constructor() async {
    final assisted = await _assist('''
class Diary {
  Diary();
}
''', 'Diary();');
    expect(assisted, '''
class Diary {
  /// {@macro test.Diary}
  Diary();
}
''');
  }

  Future<void> test_namedConstructor() async {
    final assisted = await _assist('''
class Diary {
  Diary.empty();
}
''', 'empty');
    expect(assisted, '''
class Diary {
  /// {@macro test.Diary}
  Diary.empty();
}
''');
  }

  Future<void> test_method() async {
    final assisted = await _assist('''
class Diary {
  void open() {}
}
''', 'open');
    expect(assisted, '''
class Diary {
  /// {@macro test.Diary.open}
  void open() {}
}
''');
  }

  Future<void> test_methodOfEnum() async {
    final assisted = await _assist('''
enum Mood {
  good;

  void show() {}
}
''', 'show');
    expect(assisted, contains('  /// {@macro test.Mood.show}\n  void show'));
  }

  Future<void> test_inBody() async {
    expect(
      await _assist('''
class Diary {
  void open() {}
}
''', '{}'),
      isNull,
    );
  }

  Future<void> test_documented() async {
    expect(
      await _assist('''
class Diary {
  /// Opens the diary.
  void open() {}
}
''', 'open'),
      isNull,
    );
  }

  Future<void> test_field() async {
    expect(
      await _assist('''
class Diary {
  final int page = 0;
}
''', 'page'),
      isNull,
    );
  }

  Future<void> test_extensionMethod() async {
    expect(
      await _assist('''
extension Pages on int {
  void open() {}
}
''', 'open'),
      isNull,
    );
  }

  Future<void> test_withoutPubspec() async {
    final path = convertPath('$workspaceRootPath/notes/diary.dart');
    newFile(path, '''
class Diary {
  void open() {}
}
''');
    await assertNoDiagnosticsInFile(path);
    final assisted = await applyCorrection(
      AddMacroDocumentComment.new,
      selectionOffset: 20,
    );
    expect(assisted, isNull);
  }

  Future<void> test_kind() async {
    await assertNoDiagnostics('class Diary {}\n');
    final producer = await createCorrection(AddMacroDocumentComment.new);
    expect(
      producer.assistKind?.id,
      'one_page_lints.assist.addMacroDocumentComment',
    );
    expect(producer.canBeAppliedAcrossSingleFile, isFalse);
    expect(producer.canBeAppliedAcrossFiles, isFalse);
  }
}
