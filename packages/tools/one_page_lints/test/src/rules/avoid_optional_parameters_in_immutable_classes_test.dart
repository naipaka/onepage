import 'package:one_page_lints/src/rules/avoid_optional_parameters_in_immutable_classes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidOptionalParametersInImmutableClassesTest);
  });
}

@reflectiveTest
class AvoidOptionalParametersInImmutableClassesTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidOptionalParametersInImmutableClasses();
    super.setUp();
  }

  Future<void> test_optionalParameters() async {
    const code = '''
import 'package:flutter/foundation.dart';

@immutable
class Setting {
  const Setting({required this.hour, this.note, this.tags = const []});

  const Setting.morning([this.hour = 8, this.note, this.tags = const []]);

  factory Setting.fromJson(Map<String, dynamic> json, {int fallback = 0}) =>
      Setting(hour: json['hour'] as int? ?? fallback, note: null, tags: []);

  final int hour;
  final String? note;
  final List<String> tags;
}
''';
    final first = code.indexOf('this.note');
    final second = code.indexOf('this.hour = 8');
    await assertDiagnostics(code, [
      lint(first + 5, 4),
      lint(code.indexOf('tags', first), 4),
      lint(second + 5, 4),
      lint(code.indexOf('note', second), 4),
      lint(code.indexOf('tags', second), 4),
      lint(code.indexOf('fallback'), 8),
    ]);
  }

  Future<void> test_declaringConstructor() async {
    const code = '''
import 'package:flutter/foundation.dart';

@immutable
class Setting(final int hour, [final String? note]);
''';
    await assertDiagnostics(code, [lint(code.indexOf('note'), 4)]);
  }

  Future<void> test_requiredParameters() async {
    await assertNoDiagnostics('''
import 'package:flutter/foundation.dart';

@immutable
class Setting {
  const Setting(this.hour, {required this.note});

  final int hour;
  final String? note;
}
''');
  }

  Future<void> test_mutableClass() async {
    await assertNoDiagnostics('''
class Setting {
  Setting({this.note});

  final String? note;
}
''');
  }
}
