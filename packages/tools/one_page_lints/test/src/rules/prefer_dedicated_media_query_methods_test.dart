import 'package:one_page_lints/src/rules/prefer_dedicated_media_query_methods.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferDedicatedMediaQueryMethodsTest);
  });
}

@reflectiveTest
class PreferDedicatedMediaQueryMethodsTest extends RuleTestBase {
  @override
  void setUp() {
    rule = PreferDedicatedMediaQueryMethods();
    super.setUp();
  }

  Future<void> test_of() async {
    const code = '''
import 'package:flutter/widgets.dart';

Size size(BuildContext context) => MediaQuery.of(context).size;
''';
    await assertLintsOn(code, ['MediaQuery.of(context)']);
  }

  Future<void> test_maybeOf() async {
    const code = '''
import 'package:flutter/widgets.dart';

Size? size(BuildContext context) => MediaQuery.maybeOf(context)?.size;
''';
    await assertLintsOn(code, ['MediaQuery.maybeOf(context)']);
  }

  Future<void> test_ofCopied() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

MediaQueryData copy(BuildContext context) => MediaQuery.of(context).copyWith();
''');
  }

  Future<void> test_sizeOfWidth() async {
    const code = '''
import 'package:flutter/widgets.dart';

double width(BuildContext context) => MediaQuery.sizeOf(context).width;
''';
    await assertLintsOn(code, ['MediaQuery.sizeOf(context).width']);
  }

  Future<void> test_sizeOfHeight() async {
    const code = '''
import 'package:flutter/widgets.dart';

double height(BuildContext context) => MediaQuery.sizeOf(context).height;
''';
    await assertLintsOn(code, ['MediaQuery.sizeOf(context).height']);
  }

  Future<void> test_sizeOf() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Size size(BuildContext context) => MediaQuery.sizeOf(context);
''');
  }

  Future<void> test_widthOf() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

double width(BuildContext context) => MediaQuery.widthOf(context);
''');
  }

  Future<void> test_otherClass() async {
    await assertNoDiagnostics('''
class Query {
  static int of(Object context) => 0;
}

final value = Query.of(Object());
''');
  }
}
