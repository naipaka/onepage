import 'package:one_page_lints/src/rules/prefer_clock_now.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferClockNowTest);
  });
}

@reflectiveTest
class PreferClockNowTest extends RuleTestBase {
  @override
  void setUp() {
    rule = PreferClockNow();
    super.setUp();
  }

  Future<void> test_now() async {
    const code = 'final now = DateTime.now();';
    await assertLintsOn(code, ['DateTime.now()']);
  }

  Future<void> test_timestamp() async {
    const code = 'final now = DateTime.timestamp();';
    await assertLintsOn(code, ['DateTime.timestamp()']);
  }

  Future<void> test_otherConstructor() async {
    await assertNoDiagnostics('final date = DateTime(2026);');
  }

  Future<void> test_otherClass() async {
    await assertNoDiagnostics('''
class DateTime {
  DateTime.now();
}

final now = DateTime.now();
''');
  }
}
