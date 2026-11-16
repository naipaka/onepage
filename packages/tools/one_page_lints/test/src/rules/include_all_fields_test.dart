import 'package:one_page_lints/src/rules/include_all_fields.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(IncludeAllFieldsTest);
  });
}

@reflectiveTest
class IncludeAllFieldsTest extends RuleTestBase {
  @override
  void setUp() {
    rule = IncludeAllFields();
    super.setUp();
  }

  Future<void> test_allFieldsIncluded() async {
    await assertNoDiagnostics(r'''
import 'package:flutter/foundation.dart';

@immutable
class Setting {
  const Setting({required this.hour, required this.isEnabled});

  static const maxHour = 23;

  final int hour;
  final bool isEnabled;

  int get minutes => hour * 60;

  Setting copyWith({int? hour, bool? isEnabled}) => Setting(
    hour: hour ?? this.hour,
    isEnabled: isEnabled ?? this.isEnabled,
  );

  Map<String, dynamic> toJson() => {'hour': hour, 'isEnabled': isEnabled};

  String describe() => '$hour';

  static Map<String, dynamic> toJsonOf(Setting setting) => {};

  @override
  bool operator ==(Object other) =>
      other is Setting && other.hour == hour && other.isEnabled == isEnabled;

  @override
  int get hashCode => Object.hash(hour, isEnabled);

  @override
  String toString() => 'Setting(hour: $hour, isEnabled: $isEnabled)';
}
''');
  }

  Future<void> test_missingFields() async {
    const code = r'''
import 'package:flutter/foundation.dart';

@immutable
class Setting {
  const Setting({required this.hour, required this.isEnabled});

  final int hour;
  final bool isEnabled;

  Setting copyWith({int? hour}) =>
      Setting(hour: hour ?? this.hour, isEnabled: true);

  Map<String, dynamic> toJson() => {'hour': hour};

  @override
  bool operator ==(Object other) => other is Setting && other.hour == hour;

  @override
  int get hashCode => isEnabled.hashCode;

  @override
  String toString() => 'Setting(isEnabled: $isEnabled)';
}
''';
    await assertDiagnostics(code, [
      lint(code.indexOf('copyWith'), 8),
      lint(code.indexOf('toJson'), 6),
      lint(code.indexOf('=='), 2),
      lint(code.indexOf('hashCode =>'), 8),
      lint(code.indexOf('toString'), 8),
    ]);
  }

  Future<void> test_declaringConstructor() async {
    const code = '''
import 'package:flutter/foundation.dart';

@immutable
class Setting(final int hour, final bool isEnabled) {
  @override
  int get hashCode => hour.hashCode;
}
''';
    await assertDiagnostics(code, [lint(code.indexOf('hashCode =>'), 8)]);
  }

  Future<void> test_mutableClass() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour, this.isEnabled);

  final int hour;
  final bool isEnabled;

  Map<String, dynamic> toJson() => {'hour': hour};
}
''');
  }

  Future<void> test_classWithoutBody() async {
    await assertNoDiagnostics('''
import 'package:flutter/foundation.dart';

@immutable
class Setting(final int hour);
''');
  }
}
