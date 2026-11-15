import 'package:one_page_lints/src/rules/avoid_consecutive_sliver_to_box_adapter.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidConsecutiveSliverToBoxAdapterTest);
  });
}

@reflectiveTest
class AvoidConsecutiveSliverToBoxAdapterTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidConsecutiveSliverToBoxAdapter();
    super.setUp();
  }

  Future<void> test_consecutive() async {
    const code = '''
import 'package:flutter/widgets.dart';

const slivers = [
  SliverToBoxAdapter(),
  SliverToBoxAdapter(child: Placeholder()),
];
''';
    await assertLintsOn(code, ['SliverToBoxAdapter(child: Placeholder())']);
  }

  Future<void> test_threeConsecutive() async {
    const code = '''
import 'package:flutter/widgets.dart';

const slivers = [
  SliverToBoxAdapter(key: ValueKey(1)),
  SliverToBoxAdapter(key: ValueKey(2)),
  SliverToBoxAdapter(key: ValueKey(3)),
];
''';
    await assertLintsOn(code, [
      'SliverToBoxAdapter(key: ValueKey(2))',
      'SliverToBoxAdapter(key: ValueKey(3))',
    ]);
  }

  Future<void> test_inSliverPadding() async {
    const code = '''
import 'package:flutter/widgets.dart';

const slivers = [
  SliverToBoxAdapter(),
  SliverPadding(padding: EdgeInsets.zero, sliver: SliverToBoxAdapter()),
];
''';
    await assertLintsOn(code, [
      'SliverPadding(padding: EdgeInsets.zero, sliver: SliverToBoxAdapter())',
    ]);
  }

  Future<void> test_separated() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final slivers = [
  const SliverToBoxAdapter(),
  SliverList.list(children: const []),
  const SliverToBoxAdapter(),
];
''');
  }

  Future<void> test_otherSliverInPadding() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final slivers = [
  const SliverToBoxAdapter(),
  SliverPadding(
    padding: EdgeInsets.zero,
    sliver: SliverList.list(children: const []),
  ),
];
''');
  }

  Future<void> test_collectionElement() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

const slivers = [
  SliverToBoxAdapter(),
  ...[SliverToBoxAdapter()],
];
''');
  }

  Future<void> test_otherExpression() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

Widget adapter() => const SliverToBoxAdapter();

final slivers = [const SliverToBoxAdapter(), adapter()];
''');
  }
}
