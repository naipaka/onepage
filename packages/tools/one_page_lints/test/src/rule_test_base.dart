import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';

/// {@template one_page_lints.RuleTestBase}
/// A rule test whose test package depends on a mock Flutter package.
///
/// The mock of analyzer_testing lacks some of the classes and members that the
/// rules look for, and so does the mock SDK, so this test adds them.
///
/// [assertLintsOn] finds where the lints are expected in the test code, and
/// [createCorrection] and [applyCorrection] run a fix or an assist on the code
/// resolved last.
/// {@endtemplate}
abstract class RuleTestBase extends AnalysisRuleTest {
  @override
  bool get addFlutterPackageDep => true;

  @override
  void setUp() {
    super.setUp();
    _insertAfter(
      sdkRoot
          .getFolder('lib')
          .getFile(
            'core/core.dart',
          ),
      '  DateTime.now() : this._now();',
      '  DateTime.timestamp() : this._now();\n'
          '  DateTime(int year) : this._now();',
    );
  }

  @override
  Folder addSkyEngine({required String sdkPath}) {
    final lib = super.addSkyEngine(sdkPath: sdkPath);
    _insertAfter(
      getFile(convertPath('$packagesRootPath/ui/lib/ui.dart')),
      'class Color {',
      '  static Color? lerp(Color? a, Color? b, double t) => a;',
    );
    return lib;
  }

  @override
  Folder addFlutter() {
    final lib = super.addFlutter();
    _insertAfter(
      lib.getFile('src/material/colors.dart'),
      'abstract final class Colors {',
      '  static const Color transparent = Color(0x00000000);',
    );
    newFile('${lib.path}/src/material/color_scheme.dart', '''
import 'dart:ui';

class ColorScheme {
  const ColorScheme.light({Color? primary});

  factory ColorScheme.fromSeed({required Color seedColor}) =>
      const ColorScheme.light();

  ColorScheme copyWith({Color? primary}) => this;
}
''');
    newFile('${lib.path}/src/widgets/media_query.dart', '''
import 'dart:ui';

import 'framework.dart';

class MediaQuery {
  static MediaQueryData of(BuildContext context) => throw 0;

  static MediaQueryData? maybeOf(BuildContext context) => throw 0;

  static Size sizeOf(BuildContext context) => throw 0;

  static double widthOf(BuildContext context) => throw 0;
}

class MediaQueryData {
  const MediaQueryData();

  Size get size => throw 0;

  MediaQueryData copyWith() => this;
}
''');
    newFile('${lib.path}/src/widgets/extra_widgets.dart', '''
import 'framework.dart';
import 'scroll_view.dart';

abstract class BoxScrollView extends ScrollView {
  const BoxScrollView({super.key, super.shrinkWrap});
}

class ListView extends BoxScrollView {
  const ListView({
    super.key,
    super.shrinkWrap,
    List<Widget> children = const <Widget>[],
  });
}

class GridView extends BoxScrollView {
  const GridView.count({
    super.key,
    required int crossAxisCount,
    List<Widget> children = const <Widget>[],
  });
}

class SliverMainAxisGroup extends MultiChildRenderObjectWidget {
  const SliverMainAxisGroup({super.key, required List<Widget> slivers})
    : super(children: slivers);
}

class SliverCrossAxisGroup extends MultiChildRenderObjectWidget {
  const SliverCrossAxisGroup({super.key, required List<Widget> slivers})
    : super(children: slivers);
}

class Viewport extends MultiChildRenderObjectWidget {
  const Viewport({super.key, List<Widget> slivers = const <Widget>[]})
    : super(children: slivers);
}

class ShrinkWrappingViewport extends MultiChildRenderObjectWidget {
  const ShrinkWrappingViewport({
    super.key,
    List<Widget> slivers = const <Widget>[],
  }) : super(children: slivers);
}

class Semantics extends StatelessWidget {
  const Semantics({super.key, String? label});

  @override
  Widget build(BuildContext context) => throw 0;
}

class IndexedStack extends StatelessWidget {
  const IndexedStack({super.key, List<Widget> children = const <Widget>[]});

  @override
  Widget build(BuildContext context) => throw 0;
}

''');
    newFile('${lib.path}/services.dart', '''
export 'src/services/platform_channel.dart';
''');
    newFile('${lib.path}/src/services/platform_channel.dart', '''
class MethodChannel {
  const MethodChannel(String name);

  Future<T?> invokeMethod<T>(String method, [Object? arguments]) async => null;
}
''');
    _insertAfter(
      lib.getFile('widgets.dart'),
      "export 'src/widgets/scroll_view.dart';",
      "export 'src/widgets/extra_widgets.dart';",
    );
    return lib;
  }

  /// Asserts that the rule reports [code] exactly on [targets], each of which
  /// appears once in [code].
  Future<void> assertLintsOn(String code, List<String> targets) =>
      assertDiagnostics(code, [
        for (final target in targets)
          lint(_offsetOf(code, target), target.length),
      ]);

  int _offsetOf(String code, String target) {
    final offset = code.indexOf(target);
    if (offset < 0 || code.contains(target, offset + 1)) {
      throw ArgumentError.value(target, 'target', 'Must appear once in code');
    }
    return offset;
  }

  /// The producer that [create] makes for [diagnostic] or at
  /// [selectionOffset] in the code resolved last.
  Future<ResolvedCorrectionProducer> createCorrection(
    ResolvedCorrectionProducer Function({
      required CorrectionProducerContext context,
    })
    create, {
    Diagnostic? diagnostic,
    int selectionOffset = -1,
  }) async {
    final libraryResult = await result.session.getResolvedLibrary(
      result.path,
    ) as ResolvedLibraryResult;
    return create(
      context: CorrectionProducerContext.createResolved(
        libraryResult: libraryResult,
        unitResult: result,
        diagnostic: diagnostic,
        selectionOffset: diagnostic?.offset ?? selectionOffset,
        selectionLength: diagnostic?.length ?? 0,
      ),
    );
  }

  /// The code resolved last after the correction that [create] makes for
  /// [diagnostic] or at [selectionOffset], or null when it makes none.
  Future<String?> applyCorrection(
    ResolvedCorrectionProducer Function({
      required CorrectionProducerContext context,
    })
    create, {
    Diagnostic? diagnostic,
    int selectionOffset = -1,
  }) async {
    final producer = await createCorrection(
      create,
      diagnostic: diagnostic,
      selectionOffset: selectionOffset,
    );
    final builder = ChangeBuilder(session: result.session);
    await producer.compute(builder);
    final fileEdits = builder.sourceChange.edits;
    if (fileEdits.isEmpty) {
      return null;
    }
    return SourceEdit.applySequence(result.content, fileEdits.single.edits);
  }

  /// The path of [name] in the test directory of the test package.
  String testDirectoryFile(String name) =>
      convertPath('$testPackageRootPath/test/$name');

  void _insertAfter(File file, String anchor, String lines) {
    final content = file.readAsStringSync();
    if (!content.contains(anchor)) {
      throw StateError('$anchor is not in ${file.path}.');
    }
    file.writeAsStringSync(content.replaceFirst(anchor, '$anchor\n$lines'));
  }
}
