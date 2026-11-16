import 'package:one_page_lints/src/rules/matching_asset_files.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(MatchingAssetFilesTest);
  });
}

@reflectiveTest
class MatchingAssetFilesTest extends RuleTestBase {
  @override
  void setUp() {
    rule = MatchingAssetFiles();
    super.setUp();
    newFile(_assetPath('icon.png'), '');
    newFile(_assetPath('images/backup.png'), '');
    newFile(_assetPath('images/.DS_Store'), '');
    newFile(_assetPath('images/2.0x/backup.png'), '');
  }

  String _assetPath(String name) =>
      convertPath('$testPackageRootPath/assets/$name');

  void _writePubspec(String assets) {
    newPubspecYamlFile(testPackageRootPath, '''
name: test
flutter:
  assets:
$assets
''');
  }

  static String _appAsset(List<String> paths) =>
      '''
enum AppAsset {
${[for (final (index, path) in paths.indexed) "  asset$index('$path')"].join(',\n')};

  new(this.path);

  final String path;
}
''';

  Future<void> test_matchingFilesAndDirectories() async {
    _writePubspec('''
    - assets/icon.png
    - assets/images/
''');
    await assertNoDiagnostics(
      _appAsset(['assets/icon.png', 'assets/images/backup.png']),
    );
  }

  Future<void> test_matchingPathEntry() async {
    _writePubspec('''
    - path: assets/icon.png
      flavors:
        - dev
''');
    await assertNoDiagnostics(_appAsset(['assets/icon.png']));
  }

  Future<void> test_valueWithoutFile() async {
    _writePubspec('''
    - assets/icon.png
''');
    final code = _appAsset(['assets/icon.png', 'assets/logo.png']);
    await assertDiagnostics(code, [
      lint(
        code.indexOf("'assets/logo.png'"),
        17,
        messageContainsAll: ["'assets/logo.png' is only in AppAsset"],
      ),
    ]);
  }

  Future<void> test_fileWithoutValue() async {
    _writePubspec('''
    - assets/
    - assets/images/
''');
    final code = _appAsset(['assets/icon.png']);
    await assertDiagnostics(code, [
      lint(
        code.indexOf('AppAsset'),
        8,
        messageContainsAll: [
          "'assets/images/backup.png' is only in pubspec.yaml",
        ],
      ),
    ]);
  }

  Future<void> test_missingEntries() async {
    _writePubspec('''
    - assets/missing.png
    - assets/missing/
    - 1
''');
    final code = _appAsset(['assets/icon.png']);
    await assertLintsOn(code, ["'assets/icon.png'"]);
  }

  Future<void> test_noAssets() async {
    newPubspecYamlFile(testPackageRootPath, 'name: test\n');
    final code = _appAsset(['assets/icon.png']);
    await assertLintsOn(code, ["'assets/icon.png'"]);
  }

  Future<void> test_noPubspec() async {
    deleteFile(convertPath('$testPackageRootPath/pubspec.yaml'));
    final code = _appAsset(['assets/icon.png']);
    await assertLintsOn(code, ["'assets/icon.png'"]);
  }

  Future<void> test_otherEnum() async {
    _writePubspec('''
    - assets/icon.png
''');
    await assertNoDiagnostics('''
enum Other {
  logo('assets/logo.png');

  new(this.path);

  final String path;
}
''');
  }

  Future<void> test_valueWithoutLiteral() async {
    _writePubspec('''
    - assets/icon.png
''');
    const code = '''
const iconPath = 'assets/icon.png';

enum AppAsset {
  icon(iconPath);

  new(this.path);

  final String path;
}
''';
    await assertDiagnostics(code, [lint(code.indexOf('AppAsset'), 8)]);
  }
}
