import 'package:one_page_lints/src/rules/avoid_ignore_comments.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidIgnoreCommentsTest);
  });
}

@reflectiveTest
class AvoidIgnoreCommentsTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidIgnoreComments();
    super.setUp();
  }

  Future<void> test_ignore() async {
    const code = '''
// ignore: unused_element
void _unused() {}
''';
    await assertLintsOn(code, ['// ignore: unused_element']);
  }

  Future<void> test_ignoreAboveADocumentedDeclaration() async {
    const code = '''
// ignore: unused_element
/// Not used.
void _unused() {}
''';
    await assertLintsOn(code, ['// ignore: unused_element']);
  }

  Future<void> test_ignoreAtTheEndOfALine() async {
    const code = 'void _unused() {} // ignore: unused_element\n';
    await assertLintsOn(code, ['// ignore: unused_element']);
  }

  Future<void> test_ignoreForFile() async {
    const code = '''
// ignore_for_file: unused_element
void _unused() {}
''';
    await assertLintsOn(code, ['// ignore_for_file: unused_element']);
  }

  /// The analysis server applies ignore comments to the rules of plugins
  /// too, so `type=lint` hides this rule. The `ignore-comments:ci` script finds
  /// such comments instead. When this test fails, the analysis server no longer
  /// lets the comment hide this rule, and the script can go.
  Future<void> test_ignoreHidesThisRule() async {
    await assertNoDiagnostics('''
// ignore_for_file: type=lint
void _unused() {}
''');
  }

  Future<void> test_ignoreInADocumentationComment() async {
    const code = '''
/// ignore: unused_element
void _unused() {}
''';
    await assertLintsOn(code, ['/// ignore: unused_element']);
  }

  Future<void> test_ignoreWithoutSpace() async {
    const code = '''
//ignore: unused_element
void _unused() {}
''';
    await assertLintsOn(code, ['//ignore: unused_element']);
  }

  Future<void> test_ignoreInsideABody() async {
    const code = '''
void f() {
  // ignore: unused_local_variable
  final value = 1;
}
''';
    await assertLintsOn(code, ['// ignore: unused_local_variable']);
  }

  Future<void> test_otherComments() async {
    await assertNoDiagnostics('''
// Taps are ignored while the photo loads.
/// The quality is ignored for PNG.
// ignore taps: no colon after ignore.
/// ignore_for_file: only two slashes are read as this comment.
void f() {}
''');
  }

  Future<void> test_generatedFiles() async {
    for (final name in [
      'lib/src/notes.g.dart',
      'lib/src/notes.steps.dart',
      'patrol_test/test_bundle.dart',
      'test/drift/generated/schema.dart',
      'lib/environment/src/firebase_options_dev.dart',
    ]) {
      final path = convertPath('$testPackageRootPath/$name');
      newFile(path, '''
// ignore_for_file: unused_element
void _unused() {}
''');
      await assertNoDiagnosticsInFile(path);
    }
  }

  Future<void> test_firebaseOptionsSelector() async {
    final path = convertPath(
      '$testPackageRootPath/lib/environment/src/firebase_options.dart',
    );
    newFile(path, '''
// ignore_for_file: unused_element
void _unused() {}
''');
    await assertDiagnosticsInFile(path, [lint(0, 34)]);
  }

  Future<void> test_generatedPart() async {
    newFile(convertPath('$testPackageRootPath/lib/notes.dart'), '''
part 'notes.g.dart';
''');
    final path = convertPath('$testPackageRootPath/lib/notes.g.dart');
    newFile(path, '''
part of 'notes.dart';

// ignore_for_file: unused_element
void _unused() {}
''');
    await assertNoDiagnosticsInFile(path);
  }

  Future<void> test_generatedCommentInAHandWrittenFile() async {
    const code = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element
void _unused() {}
''';
    await assertLintsOn(code, ['// ignore_for_file: unused_element']);
  }
}
