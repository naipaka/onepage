import 'package:one_page_lints/src/rules/avoid_shrink_wrap_in_list_view.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidShrinkWrapInListViewTest);
  });
}

@reflectiveTest
class AvoidShrinkWrapInListViewTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidShrinkWrapInListView();
    super.setUp();
  }

  Future<void> test_inColumn() async {
    const code = '''
import 'package:flutter/widgets.dart';

final widget = Column(children: [ListView(shrinkWrap: true)]);
''';
    await assertLintsOn(code, ['shrinkWrap: true']);
  }

  Future<void> test_inRow() async {
    const code = '''
import 'package:flutter/widgets.dart';

final widget = Row(children: [ListView(shrinkWrap: true)]);
''';
    await assertLintsOn(code, ['shrinkWrap: true']);
  }

  Future<void> test_inListView() async {
    const code = '''
import 'package:flutter/widgets.dart';

final widget = ListView(children: [ListView(shrinkWrap: true)]);
''';
    await assertLintsOn(code, ['shrinkWrap: true']);
  }

  Future<void> test_inNestedWidget() async {
    const code = '''
import 'package:flutter/widgets.dart';

final widget = Column(
  children: [
    Padding(padding: EdgeInsets.zero, child: ListView(shrinkWrap: true)),
  ],
);
''';
    await assertLintsOn(code, ['shrinkWrap: true']);
  }

  Future<void> test_shrinkWrapFalse() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final widget = Column(children: [ListView(shrinkWrap: false)]);
''');
  }

  Future<void> test_withoutShrinkWrap() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final widget = Column(children: [ListView()]);
''');
  }

  Future<void> test_withoutParentList() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final widget = Center(child: ListView(shrinkWrap: true));
''');
  }

  Future<void> test_otherWidget() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final widget = Column(children: [CustomScrollView(shrinkWrap: true)]);
''');
  }
}
