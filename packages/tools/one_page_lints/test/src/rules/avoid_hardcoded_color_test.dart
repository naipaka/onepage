import 'package:one_page_lints/src/rules/avoid_hardcoded_color.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidHardcodedColorTest);
  });
}

@reflectiveTest
class AvoidHardcodedColorTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidHardcodedColor();
    super.setUp();
  }

  Future<void> test_constructor() async {
    const code = '''
import 'package:flutter/material.dart';

const color = Color(0xFF123456);
''';
    await assertLintsOn(code, ['Color(0xFF123456)']);
  }

  Future<void> test_namedConstructor() async {
    const code = '''
import 'package:flutter/material.dart';

const color = Color.fromARGB(255, 0, 0, 0);
''';
    await assertLintsOn(code, ['Color.fromARGB(255, 0, 0, 0)']);
  }

  Future<void> test_staticMethod() async {
    const code = '''
import 'package:flutter/material.dart';

final color = Color.lerp(null, null, 0.5);
''';
    await assertLintsOn(code, ['Color.lerp(null, null, 0.5)']);
  }

  Future<void> test_colorsConstant() async {
    const code = '''
import 'package:flutter/material.dart';

const color = Colors.black;
''';
    await assertLintsOn(code, ['Colors.black']);
  }

  Future<void> test_materialColorsConstant() async {
    const code = '''
import 'package:flutter/material.dart';

const color = Colors.red;
''';
    await assertLintsOn(code, ['Colors.red']);
  }

  Future<void> test_prefixedColorsConstant() async {
    const code = '''
import 'package:flutter/material.dart' as material;

const color = material.Colors.black;
''';
    await assertLintsOn(code, ['material.Colors.black']);
  }

  Future<void> test_colorsTransparent() async {
    await assertNoDiagnostics('''
import 'package:flutter/material.dart';

const color = Colors.transparent;
''');
  }

  Future<void> test_colorsMaterialColorShade() async {
    const code = '''
import 'package:flutter/material.dart';

final color = Colors.red.shade700;
''';
    await assertLintsOn(code, ['Colors.red']);
  }

  Future<void> test_colorSchemeConstructor() async {
    await assertNoDiagnostics('''
import 'package:flutter/material.dart';

const scheme = ColorScheme.light(primary: Color(0xFF123456));
''');
  }

  Future<void> test_colorSchemeFactory() async {
    await assertNoDiagnostics('''
import 'package:flutter/material.dart';

final scheme = ColorScheme.fromSeed(seedColor: Colors.black);
''');
  }

  Future<void> test_colorSchemeMethod() async {
    await assertNoDiagnostics('''
import 'package:flutter/material.dart';

final scheme = const ColorScheme.light().copyWith(primary: Colors.black);
''');
  }

  Future<void> test_colorFromVariable() async {
    await assertNoDiagnostics('''
import 'package:flutter/material.dart';

Color pick(ColorScheme scheme, Color color) => color;
''');
  }

  Future<void> test_otherStaticMethod() async {
    await assertNoDiagnostics('''
class Palette {
  static int lerp(int a, int b) => a;
}

final value = Palette.lerp(0, 1);
''');
  }

  Future<void> test_otherClassConstant() async {
    await assertNoDiagnostics('''
class Palette {
  static const int black = 0;
}

const value = Palette.black;
''');
  }

  Future<void> test_testDirectory() async {
    final path = testDirectoryFile('color_test.dart');
    newFile(path, '''
import 'package:flutter/material.dart';

const color = Color(0xFF123456);
''');
    await assertNoDiagnosticsInFile(path);
  }

  Future<void> test_materialUiPackage() async {
    newPackage('material_ui').addFile('lib/material_ui.dart', '''
import 'dart:ui';

export 'dart:ui' show Color;

abstract final class Colors {
  static const Color black = Color(0xFF000000);
}

class ColorScheme {
  const ColorScheme.light({Color? primary});
}
''');
    writeTestPackageConfig2();
    const code = '''
import 'package:material_ui/material_ui.dart';

const scheme = ColorScheme.light(primary: Colors.black);
const color = Colors.black;
''';
    await assertDiagnostics(code, [lint(code.lastIndexOf('Colors.black'), 12)]);
  }
}
