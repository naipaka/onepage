import 'package:one_page_lints/src/rules/matching_json_keys.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MatchingJsonKeysTest);
  });
}

@reflectiveTest
class MatchingJsonKeysTest extends RuleTestBase {
  @override
  void setUp() {
    rule = MatchingJsonKeys();
    super.setUp();
  }

  Future<void> test_differentKeys() async {
    await assertLintsOn(
      '''
class Setting {
  Setting({required this.hour, required this.isEnabled});

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    hour: json['hour'] as int,
    isEnabled: json['is_enabled'] as bool,
  );

  final int hour;
  final bool isEnabled;

  Map<String, dynamic> toJson() => {'hour': hour, 'isEnabled': isEnabled};
}
''',
      ["'is_enabled'", "'isEnabled'"],
    );
  }

  Future<void> test_sameKeys() async {
    await assertNoDiagnostics('''
class Setting {
  Setting({required this.hour, required this.isEnabled});

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
    hour: (json['hour'] as num).toInt(),
    isEnabled: json['isEnabled']! as bool,
  );

  final int hour;
  final bool isEnabled;

  Map<String, dynamic> toJson() => {'hour': hour, 'isEnabled': isEnabled};
}
''');
  }

  Future<void> test_primaryConstructorFactory() async {
    await assertLintsOn(
      '''
class Setting {
  const new({required this.hour});

  factory fromJson(Map<String, dynamic> json) =>
      Setting(hour: json['hours'] as int);

  final int hour;

  Map<String, dynamic> toJson() => {'hour': hour};
}
''',
      ["'hours'", "'hour'"],
    );
  }

  Future<void> test_initializerList() async {
    await assertLintsOn(
      '''
class Setting {
  Setting.fromJson(Map<String, dynamic> json)
    : hour = json['hours'] as int;

  final int hour;

  Map<String, dynamic> toJson() => {'hour': hour};
}
''',
      ["'hours'", "'hour'"],
    );
  }

  Future<void> test_staticMethodAndBlockBody() async {
    await assertLintsOn(
      '''
class Setting {
  Setting(this.hour);

  static Setting fromJson(Map<String, dynamic> json) =>
      Setting(json['hour'] as int);

  final int hour;

  Map<String, dynamic> toJson() {
    if (hour < 0) {
      return {'hour': 0};
    }
    return {'hour': hour, 'minute': 0};
  }
}
''',
      ["'minute'"],
    );
  }

  Future<void> test_otherIndexes() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour);

  factory Setting.fromJson(Map<String, dynamic> json) {
    const defaults = {'minute': 0};
    const key = 'second';
    return Setting((json['hour'] as int) + defaults['minute']! + (json[key] as int));
  }

  final int hour;

  Map<String, dynamic> toJson() => {'hour': hour};
}
''');
  }

  Future<void> test_withoutToJson() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour);

  factory Setting.fromJson(Map<String, dynamic> json) =>
      Setting(json['hours'] as int);

  final int hour;

  static Map<String, dynamic> toJson(Setting setting) => {'hour': 0};
}
''');
  }

  Future<void> test_withoutFromJson() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour);

  Setting.parse(Map<String, dynamic> json) : hour = json['hours'] as int;

  final int hour;

  Setting fromJson(Map<String, dynamic> json) => Setting(json['hours'] as int);

  Map<String, dynamic> toJson() => {'hour': hour};
}
''');
  }

  Future<void> test_fromJsonWithoutParameter() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour);

  static Setting get fromJson => Setting(0);

  final int hour;

  Map<String, dynamic> toJson() => {'hour': hour};
}
''');
  }

  Future<void> test_fromJsonWithoutIndex() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour);

  factory Setting.fromJson(Map<String, dynamic> json) => _fromJson(json);

  final int hour;

  Map<String, dynamic> toJson() => {'hour': hour};
}

Setting _fromJson(Map<String, dynamic> json) => Setting(0);
''');
  }

  Future<void> test_toJsonReturningOtherExpression() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour);

  factory Setting.fromJson(Map<String, dynamic> json) =>
      Setting(json['hours'] as int);

  final int hour;

  Map<String, dynamic> toJson() => _toJson(this);
}

Map<String, dynamic> _toJson(Setting setting) => {'hour': setting.hour};
''');
  }

  Future<void> test_toJsonWithOtherElements() async {
    await assertNoDiagnostics('''
const _keys = {'hour': 0};

class Setting {
  Setting(this.hour);

  factory Setting.fromJson(Map<String, dynamic> json) =>
      Setting(json['hours'] as int);

  final int hour;

  Map<String, dynamic> toJson() => {..._keys, 'hour': hour};
}
''');
  }

  Future<void> test_toJsonWithoutReturn() async {
    await assertNoDiagnostics('''
class Setting {
  Setting(this.hour);

  factory Setting.fromJson(Map<String, dynamic> json) =>
      Setting(json['hours'] as int);

  final int hour;

  Map<String, dynamic> toJson() {
    throw ArgumentError();
  }
}
''');
  }

  Future<void> test_classWithoutBody() async {
    await assertNoDiagnostics('''
class Setting(final int hour);
''');
  }
}
