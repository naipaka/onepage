import 'package:one_page_lints/src/rules/prefer_space_between_elements.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferSpaceBetweenElementsTest);
  });
}

@reflectiveTest
class PreferSpaceBetweenElementsTest extends RuleTestBase {
  @override
  void setUp() {
    rule = PreferSpaceBetweenElements();
    super.setUp();
  }

  Future<void> test_fieldThenConstructor() async {
    const code = '''
class Diary {
  final int id = 0;
  Diary();
}
''';
    await assertLintsOn(code, ['Diary();']);
  }

  Future<void> test_constructorThenField() async {
    const code = '''
class Diary {
  Diary();
  final int id = 0;
}
''';
    await assertLintsOn(code, ['final int id = 0;']);
  }

  Future<void> test_constructorThenBuild() async {
    const code = '''
class Diary {
  Diary();
  void build() {}
}
''';
    await assertLintsOn(code, ['void build() {}']);
  }

  Future<void> test_fieldThenBuild() async {
    const code = '''
class Diary {
  final int id = 0;
  void build() {}
}
''';
    await assertLintsOn(code, ['void build() {}']);
  }

  Future<void> test_commentWithoutBlankLine() async {
    const code = '''
class Diary {
  final int id = 0;
  // Creates a diary.
  Diary();
}
''';
    await assertLintsOn(code, ['Diary();']);
  }

  Future<void> test_docCommentWithoutBlankLine() async {
    const code = '''
class Diary {
  final int id = 0;
  /// Creates a diary.
  Diary();
}
''';
    await assertLintsOn(code, ['/// Creates a diary.\n  Diary();']);
  }

  Future<void> test_blankLines() async {
    await assertNoDiagnostics('''
class Diary {
  Diary();

  final int id = 0;

  // Builds the diary.
  void build() {}
}
''');
  }

  Future<void> test_blankLineBeforeDocComment() async {
    await assertNoDiagnostics('''
class Diary {
  final int id = 0;

  /// Creates a diary.
  Diary();
}
''');
  }

  Future<void> test_otherMembers() async {
    await assertNoDiagnostics('''
class Diary {
  final int id = 0;
  final int page = 0;
  void open() {}
  Diary();
  Diary.empty();
  void close() {}
}
''');
  }

  Future<void> test_mixin() async {
    await assertNoDiagnostics('''
mixin Diary {
  final int id = 0;
  void build() {}
}
''');
  }
}
