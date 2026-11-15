import 'package:one_page_lints/src/rules/avoid_hardcoded_japanese.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidHardcodedJapaneseTest);
  });
}

@reflectiveTest
class AvoidHardcodedJapaneseTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidHardcodedJapanese();
    super.setUp();
  }

  Future<void> test_hiragana() async {
    const code = "const text = 'にっき';";
    await assertLintsOn(code, ["'にっき'"]);
  }

  Future<void> test_katakana() async {
    const code = "const text = 'ページ';";
    await assertLintsOn(code, ["'ページ'"]);
  }

  Future<void> test_kanji() async {
    const code = "const text = '日記';";
    await assertLintsOn(code, ["'日記'"]);
  }

  Future<void> test_halfWidthKatakana() async {
    const code = "const text = 'ﾍﾟｰｼﾞ';";
    await assertLintsOn(code, ["'ﾍﾟｰｼﾞ'"]);
  }

  Future<void> test_interpolation() async {
    const code = r'''
const count = 1;
const text = '$count 日';
''';
    await assertLintsOn(code, [r"'$count 日'"]);
  }

  Future<void> test_interpolationWithoutJapanese() async {
    await assertNoDiagnostics(r'''
const count = 1;
const text = '$count days';
''');
  }

  Future<void> test_english() async {
    await assertNoDiagnostics("const text = 'diary';");
  }

  Future<void> test_testDirectory() async {
    final path = testDirectoryFile('diary_test.dart');
    newFile(path, "const text = '日記';");
    await assertNoDiagnosticsInFile(path);
  }
}
