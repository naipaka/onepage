import 'package:one_page_lints/src/rules/prefer_widget_class.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferWidgetClassTest);
  });
}

@reflectiveTest
class PreferWidgetClassTest extends RuleTestBase {
  @override
  void setUp() {
    rule = PreferWidgetClass();
    super.setUp();
  }

  Future<void> test_function() async {
    const code = '''
import 'package:flutter/widgets.dart';

Widget title() => const Text('Title');
''';
    await assertLintsOn(code, ['title']);
  }

  Future<void> test_functionReturningSubtype() async {
    const code = '''
import 'package:flutter/widgets.dart';

Text title() => const Text('Title');
''';
    await assertLintsOn(code, ['title']);
  }

  Future<void> test_functionWithoutReturnType() async {
    const code = '''
import 'package:flutter/widgets.dart';

title() {
  return const Text('Title');
}
''';
    await assertLintsOn(code, ['title']);
  }

  Future<void> test_localFunction() async {
    const code = '''
import 'package:flutter/widgets.dart';

void show() {
  Widget title() => const Text('Title');
  print(title());
}
''';
    await assertDiagnostics(code, [lint(code.indexOf('title'), 5)]);
  }

  Future<void> test_method() async {
    const code = '''
import 'package:flutter/widgets.dart';

class Page {
  Widget title() => const Text('Title');
}
''';
    await assertLintsOn(code, ['title']);
  }

  Future<void> test_getter() async {
    const code = '''
import 'package:flutter/widgets.dart';

class Page {
  Widget get title => const Text('Title');
}
''';
    await assertLintsOn(code, ['title']);
  }

  Future<void> test_overrideInSamePackage() async {
    const code = '''
import 'package:flutter/widgets.dart';

abstract class Section {
  Widget title();
}

class DiarySection extends Section {
  @override
  Widget title() => const Text('Title');
}
''';
    await assertDiagnostics(code, [lint(code.lastIndexOf('title'), 5)]);
  }

  Future<void> test_buildOfStatelessWidget() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class Title extends StatelessWidget {
  const Title({super.key});

  @override
  Widget build(BuildContext context) => const Text('Title');
}
''');
  }

  Future<void> test_buildOfState() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class Title extends StatefulWidget {
  const Title({super.key});

  @override
  State<Title> createState() => _TitleState();
}

class _TitleState extends State<Title> {
  @override
  Widget build(BuildContext context) => const Text('Title');
}
''');
  }

  Future<void> test_overrideOfOtherPackage() async {
    newPackage('router').addFile('lib/router.dart', '''
import 'package:flutter/widgets.dart';

abstract class Route {
  Widget page();
}
''');
    writeTestPackageConfig2();
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';
import 'package:router/router.dart';

class DiaryRoute extends Route {
  @override
  Widget page() => const Text('Diary');
}
''');
  }

  Future<void> test_abstractMethod() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

abstract class Section {
  Widget title();
}
''');
  }

  Future<void> test_external() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

external Widget title();
''');
  }

  Future<void> test_nullOrWidget() async {
    const code = '''
import 'package:flutter/widgets.dart';

title(bool visible) {
  if (!visible) {
    return null;
  }
  return const Text('Title');
}
''';
    await assertLintsOn(code, ['title']);
  }

  Future<void> test_widgetOrOther() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

title(bool visible) {
  if (!visible) {
    return 'Title';
  }
  return const Text('Title');
}
''');
  }

  Future<void> test_withoutReturn() async {
    await assertNoDiagnostics('''
show() {}
''');
  }

  Future<void> test_otherReturnType() async {
    await assertNoDiagnostics('''
String title() => 'Title';
''');
  }

  Future<void> test_returnInClosure() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

builder() {
  return (BuildContext context) => const Text('Title');
}
''');
  }

  Future<void> test_inheritedWidgetLookup() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

abstract class DiaryScope extends InheritedWidget {
  static DiaryScope? of(BuildContext context) => null;

  DiaryScope? get parent => null;
}
''');
  }

  Future<void> test_testDirectory() async {
    final path = testDirectoryFile('title_test.dart');
    newFile(path, '''
import 'package:flutter/widgets.dart';

Widget title() => const Text('Title');
''');
    await assertNoDiagnosticsInFile(path);
  }
}
