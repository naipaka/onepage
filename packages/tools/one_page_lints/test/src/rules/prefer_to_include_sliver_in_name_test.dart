import 'package:one_page_lints/src/rules/prefer_to_include_sliver_in_name.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferToIncludeSliverInNameTest);
  });
}

@reflectiveTest
class PreferToIncludeSliverInNameTest extends RuleTestBase {
  @override
  void setUp() {
    rule = PreferToIncludeSliverInName();
    super.setUp();
  }

  Future<void> test_expressionBody() async {
    const code = '''
import 'package:flutter/widgets.dart';

class DiaryList extends StatelessWidget {
  const DiaryList({super.key});

  @override
  Widget build(BuildContext context) => const SliverToBoxAdapter();
}
''';
    await assertDiagnostics(code, [lint(code.indexOf('DiaryList extends'), 9)]);
  }

  Future<void> test_returnInBlock() async {
    const code = '''
import 'package:flutter/widgets.dart';

class DiaryList extends StatelessWidget {
  const DiaryList({super.key, required this.empty});

  final bool empty;

  @override
  Widget build(BuildContext context) {
    if (empty) {
      return const SizedBox();
    }
    return SliverList.list(children: const []);
  }
}
''';
    await assertDiagnostics(code, [lint(code.indexOf('DiaryList extends'), 9)]);
  }

  Future<void> test_ownSliverWidget() async {
    const code = '''
import 'package:flutter/widgets.dart';

class SliverDiaryList extends StatelessWidget {
  const SliverDiaryList({super.key});

  @override
  Widget build(BuildContext context) => const SliverToBoxAdapter();
}

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) => const SliverDiaryList();
}
''';
    await assertDiagnostics(code, [lint(code.indexOf('DiaryPage extends'), 9)]);
  }

  Future<void> test_sliverInClassName() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class SliverDiaryList extends StatelessWidget {
  const SliverDiaryList({super.key});

  @override
  Widget build(BuildContext context) => const SliverToBoxAdapter();
}
''');
  }

  Future<void> test_sliverInConstructorName() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class DiaryList extends StatelessWidget {
  const DiaryList.sliver({super.key});

  @override
  Widget build(BuildContext context) => const SliverToBoxAdapter();
}
''');
  }

  Future<void> test_returnInNestedFunction() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class DiaryList extends StatelessWidget {
  const DiaryList({super.key});

  @override
  Widget build(BuildContext context) {
    Widget adapter() {
      return const SliverToBoxAdapter();
    }

    return Builder(builder: (context) => adapter());
  }
}
''');
  }

  Future<void> test_boxWidget() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

class DiaryList extends StatelessWidget {
  const DiaryList({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox();
}
''');
  }

  Future<void> test_returnsOtherType() async {
    await assertNoDiagnostics('''
class SliverValue {}

class Diary {
  SliverValue build() => SliverValue();
}
''');
  }

  Future<void> test_withoutBuild() async {
    await assertNoDiagnostics('''
class Diary {
  void open() {}
}
''');
  }

  Future<void> test_abstractBuild() async {
    await assertNoDiagnostics('''
abstract class Diary {
  void build();
}
''');
  }

  Future<void> test_mixin() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

mixin Diary {
  Widget build() => const SliverToBoxAdapter();
}
''');
  }
}
