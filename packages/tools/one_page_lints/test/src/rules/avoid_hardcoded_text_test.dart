import 'package:one_page_lints/src/rules/avoid_hardcoded_text.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AvoidHardcodedTextTest);
  });
}

@reflectiveTest
class AvoidHardcodedTextTest extends RuleTestBase {
  @override
  void setUp() {
    rule = AvoidHardcodedText();
    super.setUp();
  }

  void _addPackage(String name, String content) {
    newPackage(name).addFile('lib/$name.dart', content);
    writeTestPackageConfig2();
  }

  Future<void> test_english() async {
    const code = "const title = 'Settings';";
    await assertLintsOn(code, ["'Settings'"]);
  }

  Future<void> test_japanese() async {
    const code = "const title = '設定';";
    await assertLintsOn(code, ["'設定'"]);
  }

  Future<void> test_upperCaseWord() async {
    const code = "const name = 'PDF';";
    await assertLintsOn(code, ["'PDF'"]);
  }

  Future<void> test_interpolation() async {
    const code = r'''
String greet(String name) => 'Hello, $name';
''';
    await assertLintsOn(code, [r"'Hello, $name'"]);
  }

  Future<void> test_identifierPassedToWidget() async {
    const code = '''
import 'package:flutter/widgets.dart';

const widget = Text('ok');
''';
    await assertLintsOn(code, ["'ok'"]);
  }

  Future<void> test_namedArgumentOfWidget() async {
    const code = '''
import 'package:flutter/widgets.dart';

const widget = Semantics(label: 'close');
''';
    await assertLintsOn(code, ["'close'"]);
  }

  Future<void> test_withoutLetters() async {
    await assertNoDiagnostics(r'''
String progress(int done, int total) => '$done / $total';
const separator = ' • ';
''');
  }

  Future<void> test_machineShapes() async {
    await assertNoDiagnostics(r'''
const channelId = 'diary_reminder';
const path = 'photo-recovery';
const url = 'https://example.com/a b';
const asset = 'assets/icon.png';
const icon = '@drawable/ic_notification';
const database = 'onepage.sqlite';
const extension = '.jpg';
String fileName(String id) => '$id.jpg';
String backupName(String app, int version) => '$app-v$version.backup';
''');
  }

  Future<void> test_directivesAndAnnotations() async {
    await assertNoDiagnostics('''
import 'dart:async' show Future;

class Note {
  const Note(this.text);

  final String text;
}

@Note('Use something else')
Future<void> old() async {}
''');
  }

  Future<void> test_assertAndThrow() async {
    await assertNoDiagnostics('''
void check(int value) {
  assert(value > 0, 'The value must be positive');
  if (value > 10) {
    throw ArgumentError('The value is too large');
  }
}

class Range {
  const Range(this.start) : assert(start >= 0, 'The start is negative');

  final int start;
}
''');
  }

  Future<void> test_toString() async {
    await assertNoDiagnostics(r'''
class Diary {
  final int id = 0;

  @override
  String toString() => 'Diary(id: $id)';
}
''');
  }

  Future<void> test_logs() async {
    _addPackage('simple_logger', '''
class SimpleLogger {
  void severe(Object message) {}
}
''');
    await assertNoDiagnostics('''
import 'package:flutter/foundation.dart';
import 'package:simple_logger/simple_logger.dart';

void report(SimpleLogger logger) {
  logger.severe('Failed to fetch the config');
  debugPrint('Opened the page');
}
''');
  }

  Future<void> test_patternsAndKeys() async {
    _addPackage('intl', '''
class DateFormat {
  DateFormat([String? pattern]);

  DateFormat.yMMMM([String? locale]);
}
''');
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

final words = RegExp('[A-Za-z]+');
final format = DateFormat('yyyy-MM-dd HH');
final month = DateFormat.yMMMM('en');
const key = Key('EndItem');
const flavor = String.fromEnvironment('Flavor Name');
''');
  }

  Future<void> test_methodChannel() async {
    await assertNoDiagnostics('''
import 'package:flutter/services.dart';

const channel = MethodChannel('Image Compressor');

Future<void> compress(String path) =>
    channel.invokeMethod('Compress Image', {'Source Path': path});
''');
  }

  Future<void> test_sql() async {
    _addPackage('drift', '''
class DatabaseConnectionUser {
  Future<void> customStatement(String statement) async {}
}
''');
    _addPackage('sqlite3', '''
class Database {
  void execute(String sql) {}
}
''');
    await assertNoDiagnostics('''
import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart';

Future<void> vacuum(DatabaseConnectionUser user, Database database) async {
  await user.customStatement('VACUUM INTO ?');
  database.execute('VACUUM INTO ?');
}
''');
  }

  Future<void> test_untranslatedTexts() async {
    await assertNoDiagnostics('''
abstract final class UntranslatedTexts {
  /// The column names of the CSV file, which other tools read.
  static const csvHeader = 'Date,Content';
}
''');
  }

  Future<void> test_untranslatedTextsWithoutComment() async {
    const code = '''
abstract final class UntranslatedTexts {
  static const csvHeader = 'Date,Content';
}
''';
    await assertLintsOn(code, ["'Date,Content'"]);
  }

  Future<void> test_untranslatedTextsOutsideConstant() async {
    const code = '''
abstract final class UntranslatedTexts {
  /// The title of the file.
  static final title = 'One Page';

  /// The heading of the file.
  static String heading() => 'Diary';
}
''';
    await assertLintsOn(code, ["'One Page'", "'Diary'"]);
  }

  Future<void> test_otherClass() async {
    const code = '''
abstract final class Texts {
  /// The column names of the CSV file.
  static const csvHeader = 'Date,Content';
}
''';
    await assertLintsOn(code, ["'Date,Content'"]);
  }

  Future<void> test_outsideLib() async {
    final path = convertPath('$testPackageRootPath/bin/main.dart');
    newFile(path, "const title = 'Settings';");
    await assertNoDiagnosticsInFile(path);
  }

  Future<void> test_generatedFile() async {
    final path = convertPath('$testPackageRootPath/lib/src/titles.g.dart');
    newFile(path, "const title = 'Settings';");
    await assertNoDiagnosticsInFile(path);
  }

  Future<void> test_generatedPart() async {
    newFile(convertPath('$testPackageRootPath/lib/titles.dart'), '''
part 'titles.g.dart';
''');
    final path = convertPath('$testPackageRootPath/lib/titles.g.dart');
    newFile(path, '''
part of 'titles.dart';

const title = 'Settings';
''');
    await assertNoDiagnosticsInFile(path);
  }

  Future<void> test_generatedCommentInAHandWrittenFile() async {
    const code = '''
// GENERATED CODE - DO NOT MODIFY BY HAND

const title = 'Settings';
''';
    await assertLintsOn(code, ["'Settings'"]);
  }

  Future<void> test_stubFolder() async {
    final path = convertPath('$testPackageRootPath/lib/src/stub/diaries.dart');
    newFile(path, "const diary = 'Woke up early today.';");
    await assertNoDiagnosticsInFile(path);
  }

  Future<void> test_folderNamedLikeAStubFile() async {
    final path = convertPath('$testPackageRootPath/lib/src/stubs/diaries.dart');
    newFile(path, "const diary = 'Woke up early today.';");
    await assertDiagnosticsInFile(path, [lint(14, 22)]);
  }

  Future<void> test_toolsPackage() async {
    newPubspecYamlFile(convertPath('/home/tools/lints'), 'name: lints');
    final path = convertPath('/home/tools/lints/lib/lints.dart');
    newFile(path, "const title = 'Settings';");
    await assertNoDiagnosticsInFile(path);
  }
}
