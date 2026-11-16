import 'package:one_page_lints/src/rules/avoid_collection_equality_checks.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidCollectionEqualityChecksTest);
  });
}

@reflectiveTest
class AvoidCollectionEqualityChecksTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidCollectionEqualityChecks();
    super.setUp();
  }

  Future<void> test_collections() async {
    await assertLintsOn(
      '''
bool f(
  List<int> list,
  Set<int> set,
  Map<String, int> map,
  Iterable<int> iterable,
) =>
    list == [1] ||
    set != {1} ||
    map == {'a': 1} ||
    iterable == list;
''',
      ['list == [1]', 'set != {1}', "map == {'a': 1}", 'iterable == list'],
    );
  }

  Future<void> test_hashCodes() async {
    const code = '''
class Tags {
  Tags(this.tags);

  final List<String> tags;

  int hashOf(Set<int> ids) =>
      ids.hashCode ^ this.tags.hashCode ^ Object.hash(1, tags);
}
''';
    await assertDiagnostics(code, [
      lint(code.indexOf('ids.hashCode'), 12),
      lint(code.indexOf('this.tags.hashCode'), 18),
      lint(code.indexOf('tags);\n}'), 4),
    ]);
  }

  Future<void> test_hashCodesOfOtherTypes() async {
    await assertNoDiagnostics('''
class Tags {
  Tags(this.tags);

  final List<String> tags;

  int hashOf(String name) =>
      name.hashCode ^
      Object.hash(name, Object.hashAll(tags)) ^
      tags.length.hashCode ^
      tags.first.hashCode ^
      hash(tags);

  int hash(Object value) => 0;
}
''');
  }

  Future<void> test_otherTypes() async {
    await assertNoDiagnostics('''
bool f(List<int>? list, Object other, String text) =>
    list == null || list == other || text == 'a' || list.length > 1;
''');
  }
}
