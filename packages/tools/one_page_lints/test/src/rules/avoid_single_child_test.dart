import 'package:one_page_lints/src/rules/avoid_single_child.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidSingleChildTest);
  });
}

@reflectiveTest
class AvoidSingleChildTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidSingleChild();
    super.setUp();
  }

  Future<void> test_column() async {
    const code = '''
import 'package:flutter/widgets.dart';

const widget = Column(children: [Placeholder()]);
''';
    await assertLintsOn(code, ['Column']);
  }

  Future<void> test_eachWidget() async {
    const code = '''
import 'package:flutter/widgets.dart';

final widgets = [
  const Row(children: [Placeholder()]),
  const Flex(direction: Axis.vertical, children: [Placeholder()]),
  const Wrap(children: [Placeholder()]),
  const Stack(children: [Placeholder()]),
  ListView(children: const [Placeholder()]),
  GridView.count(crossAxisCount: 2, children: const [Placeholder()]),
  SliverList.list(children: const [Placeholder()]),
  const SliverMainAxisGroup(slivers: [Placeholder()]),
  const SliverCrossAxisGroup(slivers: [Placeholder()]),
];
''';
    await assertLintsOn(code, [
      'Row',
      'Flex',
      'Wrap',
      'Stack',
      'ListView',
      'GridView.count',
      'SliverList.list',
      'SliverMainAxisGroup',
      'SliverCrossAxisGroup',
    ]);
  }

  Future<void> test_ifWithoutElse() async {
    const code = '''
import 'package:flutter/widgets.dart';

Widget column(bool visible) =>
    Column(children: [if (visible) const Placeholder()]);
''';
    await assertLintsOn(code, ['Column']);
  }

  Future<void> test_ifWithSingleElse() async {
    const code = '''
import 'package:flutter/widgets.dart';

Widget column(bool visible) => Column(
  children: [if (visible) const Placeholder() else const SizedBox()],
);
''';
    await assertLintsOn(code, ['Column']);
  }

  Future<void> test_spreadOfOne() async {
    const code = '''
import 'package:flutter/widgets.dart';

const widget = Column(children: [...[Placeholder()]]);
''';
    await assertLintsOn(code, ['Column']);
  }

  Future<void> test_emptyChildren() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

const widget = Column(children: []);
''');
  }

  Future<void> test_twoChildren() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

const widget = Column(children: [Placeholder(), SizedBox()]);
''');
  }

  Future<void> test_forElement() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget column(List<String> titles) =>
    Column(children: [for (final title in titles) Text(title)]);
''');
  }

  Future<void> test_spreadOfVariable() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget column(List<Widget> children) => Column(children: [...children]);
''');
  }

  Future<void> test_spreadOfMany() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

const widget = Column(children: [...[Placeholder(), SizedBox()]]);
''');
  }

  Future<void> test_ifWithMany() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget column(bool visible) =>
    Column(children: [if (visible) ...[const Placeholder(), const SizedBox()]]);
''');
  }

  Future<void> test_elseWithMany() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget column(bool visible) => Column(
  children: [
    if (visible)
      const Placeholder()
    else
      ...[const Placeholder(), const SizedBox()],
  ],
);
''');
  }

  Future<void> test_childrenVariable() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget column(List<Widget> children) => Column(children: children);
''');
  }

  Future<void> test_otherWidget() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final widget = CustomScrollView(slivers: [Placeholder()]);
''');
  }

  Future<void> test_ownSubclass() async {
    const code = '''
import 'package:flutter/widgets.dart';

class Section extends Column {
  const Section({super.key, super.children});
}

const widget = Section(children: [Placeholder()]);
''';
    await assertDiagnostics(code, [lint(code.lastIndexOf('Section'), 7)]);
  }

  Future<void> test_viewport() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

const widgets = [
  Viewport(slivers: [Placeholder()]),
  ShrinkWrappingViewport(slivers: [Placeholder()]),
];
''');
  }

  Future<void> test_statelessWidgetWithChildren() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

const widget = IndexedStack(children: [Placeholder()]);
''');
  }
}
