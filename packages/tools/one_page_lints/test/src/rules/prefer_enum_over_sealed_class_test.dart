import 'package:one_page_lints/src/rules/prefer_enum_over_sealed_class.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferEnumOverSealedClassTest);
  });
}

@reflectiveTest
class PreferEnumOverSealedClassTest extends RuleTestBase {
  @override
  void setUp() {
    rule = PreferEnumOverSealedClass();
    super.setUp();
  }

  Future<void> test_subclassesWithoutFields() async {
    const code = '''
sealed class Format {
  String get name;
}

class Pdf extends Format {
  @override
  String get name => 'pdf';
}

class Csv extends Format {
  static const extension = '.csv';

  @override
  String get name => 'csv';
}
''';
    await assertDiagnostics(code, [lint(code.indexOf('Format'), 6)]);
  }

  Future<void> test_implementingSubclasses() async {
    const code = '''
sealed class Format {}

class Pdf implements Format {}

class Csv implements Format {}
''';
    await assertDiagnostics(code, [lint(code.indexOf('Format'), 6)]);
  }

  Future<void> test_subclassWithField() async {
    const code = '''
sealed class LoadState {}

class Loading extends LoadState {}

class Failed extends LoadState {
  Failed(this.error);

  final Object error;
}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_subclassWithDeclaringConstructor() async {
    const code = '''
sealed class LoadState {}

class Loading extends LoadState {}

class Failed(final Object error) extends LoadState;
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_subclassWithTypeParameter() async {
    const code = '''
sealed class Event {}

class Started extends Event {}

class Typed<T> extends Event {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_subclassWithSubclass() async {
    const code = '''
sealed class Event {}

class Started extends Event {}

class Stopped extends Event {}

class StoppedByUser extends Stopped {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_subclassWithOtherInterface() async {
    const code = '''
abstract interface class Named {}

sealed class Event {}

class Started extends Event {}

class Stopped extends Event implements Named {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_subclassWithMixin() async {
    const code = '''
mixin Logged {}

sealed class Event {}

class Started extends Event {}

class Stopped extends Event with Logged {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_subclassWithOtherSuperclass() async {
    const code = '''
class Base {}

sealed class Event {}

class Started extends Event {}

class Stopped extends Base implements Event {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_implementingSubclassWithOtherInterface() async {
    const code = '''
abstract interface class Named {}

sealed class Event {}

class Started implements Event {}

class Stopped implements Event, Named {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_enumSubtype() async {
    const code = '''
sealed class Event {}

class Started extends Event {}

enum Stopped implements Event { byUser }
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_mixinSubtype() async {
    const code = '''
sealed class Event {}

class Started extends Event {}

mixin Stopped on Event {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_genericSealedClass() async {
    const code = '''
sealed class Event<T> {}

class Started extends Event<int> {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_sealedClassWithoutSubclasses() async {
    const code = '''
sealed class Event {}
''';
    await assertNoDiagnostics(code);
  }

  Future<void> test_classThatIsNotSealed() async {
    const code = '''
abstract class Format {}

class Pdf extends Format {}
''';
    await assertNoDiagnostics(code);
  }
}
