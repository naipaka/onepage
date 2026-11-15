import 'package:one_page_lints/src/fixes/replace_with_clock_now.dart';
import 'package:one_page_lints/src/rules/prefer_clock_now.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(ReplaceWithClockNowTest);
  });
}

@reflectiveTest
class ReplaceWithClockNowTest extends RuleTestBase {
  @override
  void setUp() {
    rule = PreferClockNow();
    super.setUp();
    newPackage('clock').addFile('lib/clock.dart', '''
Clock get clock => const Clock();

class Clock {
  const Clock();

  DateTime now() => DateTime.now();
}
''');
    writeTestPackageConfig2();
  }

  Future<String?> _fix(String code) async {
    await assertLintsOn(code, [
      if (code.contains('DateTime.now()'))
        'DateTime.now()'
      else
        'DateTime.timestamp()',
    ]);
    return applyCorrection(
      ReplaceWithClockNow.new,
      diagnostic: result.diagnostics.single,
    );
  }

  Future<void> test_now() async {
    final fixed = await _fix('final now = DateTime.now();\n');
    expect(fixed, '''
import 'package:clock/clock.dart';

final now = clock.now();
''');
  }

  Future<void> test_timestamp() async {
    final fixed = await _fix('final now = DateTime.timestamp();\n');
    expect(fixed, '''
import 'package:clock/clock.dart';

final now = clock.now().toUtc();
''');
  }

  Future<void> test_alreadyImported() async {
    final fixed = await _fix('''
import 'package:clock/clock.dart';

final today = clock.now();
final now = DateTime.now();
''');
    expect(fixed, '''
import 'package:clock/clock.dart';

final today = clock.now();
final now = clock.now();
''');
  }

  Future<void> test_clockDeclared() async {
    final fixed = await _fix('''
DateTime read(Object clock) => DateTime.now();
''');
    expect(fixed, '''
import 'package:clock/clock.dart' as clock_package;

DateTime read(Object clock) => clock_package.clock.now();
''');
  }

  Future<void> test_clockVariableDeclared() async {
    final fixed = await _fix('''
final clock = Object();
final now = DateTime.now();
''');
    expect(fixed, contains('clock_package.clock.now()'));
  }

  Future<void> test_clockMethodDeclared() async {
    final fixed = await _fix('''
class Timer {
  Object clock() => Object();

  DateTime read() => DateTime.now();
}
''');
    expect(fixed, contains('clock_package.clock.now()'));
  }

  Future<void> test_clockFunctionDeclared() async {
    final fixed = await _fix('''
Object clock() => Object();
final now = DateTime.now();
''');
    expect(fixed, contains('clock_package.clock.now()'));
  }

  Future<void> test_withoutClockPackage() async {
    newFile(
      convertPath('$testPackageRootPath/.dart_tool/package_config.json'),
      '{"configVersion": 2, "packages": []}',
    );
    final fixed = await _fix('final now = DateTime.now();\n');
    expect(fixed, isNull);
  }

  Future<void> test_otherNode() async {
    await assertNoDiagnostics('final date = DateTime(2026);\n');
    final fixed = await applyCorrection(
      ReplaceWithClockNow.new,
      selectionOffset: result.content.indexOf('DateTime'),
    );
    expect(fixed, isNull);
  }

  Future<void> test_kind() async {
    await assertNoDiagnostics('class Diary {}\n');
    final producer = await createCorrection(ReplaceWithClockNow.new);
    expect(producer.fixKind?.id, 'one_page_lints.fix.replaceWithClockNow');
    expect(producer.canBeAppliedAcrossSingleFile, isFalse);
    expect(producer.canBeAppliedAcrossFiles, isFalse);
  }
}
