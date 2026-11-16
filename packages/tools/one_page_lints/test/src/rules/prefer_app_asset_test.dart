import 'package:one_page_lints/src/rules/prefer_app_asset.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_base.dart';

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferAppAssetTest);
  });
}

@reflectiveTest
class PreferAppAssetTest extends RuleTestBase {
  static const _appAsset = '''
enum AppAsset {
  icon('assets/icon.png');

  new(this.path);

  final String path;
}
''';

  @override
  void setUp() {
    rule = PreferAppAsset();
    super.setUp();
  }

  Future<void> test_imageAssetWithLiteral() async {
    const code = '''
import 'package:flutter/widgets.dart';

final image = Image.asset('assets/icon.png', width: 64);
''';
    await assertLintsOn(code, ["'assets/icon.png'"]);
  }

  Future<void> test_assetImageWithVariable() async {
    const code = '''
import 'package:flutter/widgets.dart';

const iconPath = 'assets/icon.png';
final image = AssetImage(iconPath);
''';
    await assertDiagnostics(code, [lint(code.lastIndexOf('iconPath'), 8)]);
  }

  Future<void> test_imageAssetWithOtherPath() async {
    const code =
        '''
import 'package:flutter/widgets.dart';

$_appAsset
class Other {
  String get path => 'assets/icon.png';
}

final image = Image.asset(Other().path);
''';
    await assertLintsOn(code, ['Other().path']);
  }

  Future<void> test_imageAssetWithAppAssetPath() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

$_appAsset
final image = Image.asset(AppAsset.icon.path, width: 64);
''');
  }

  Future<void> test_assetImageWithAppAssetVariable() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

$_appAsset
AssetImage imageOf(AppAsset asset) => AssetImage(asset.path);
''');
  }

  Future<void> test_otherConstructor() async {
    await assertNoDiagnostics('''
import 'package:flutter/widgets.dart';

final image = Image.network('https://example.com/icon.png');
''');
  }

  Future<void> test_otherEnumPath() async {
    const code = '''
import 'package:flutter/widgets.dart';

enum Other {
  icon('assets/icon.png');

  new(this.path);

  final String path;
}

final image = Image.asset(Other.icon.path);
''';
    await assertLintsOn(code, ['Other.icon.path']);
  }
}
