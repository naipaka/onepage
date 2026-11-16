import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/file_system/file_system.dart';
import 'package:yaml/yaml.dart';

/// The name of the enum that lists the asset files of a package.
const appAssetName = 'AppAsset';

/// {@template one_page_lints.MatchingAssetFiles}
/// Reports an asset that only one of the enum `AppAsset` and the `assets` of
/// `pubspec.yaml` has.
///
/// The paths of `AppAsset` are the string literals given to its values. The
/// files of the `assets` of the package's `pubspec.yaml` are the files it
/// lists, and the files directly in the directories it lists, as Flutter
/// bundles them. Hidden files, such as `.DS_Store`, are left out.
///
/// ```dart
/// enum AppAsset {
///   icon('assets/icon.png'),
///   logo('assets/logo.png'); // LINT when the file is not in the assets
///
///   new(this.path);
///
///   final String path;
/// }
/// ```
/// {@endtemplate}
class MatchingAssetFiles extends AnalysisRule {
  /// {@macro one_page_lints.MatchingAssetFiles}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'matching_asset_files',
    "The asset '{0}' is only in {1}.",
    correctionMessage:
        'Try making the values of $appAssetName match the files of the '
        'assets in pubspec.yaml.',
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final root = context.package?.root;
    if (root != null) {
      registry.addEnumDeclaration(this, _Visitor(this, root));
    }
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule, this.root);

  final AnalysisRule rule;

  final Folder root;

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    if (node.namePart.typeName.lexeme != appAssetName) {
      return;
    }
    final files = _assetFiles();
    final paths = <String>{};
    for (final constant in node.body.constants) {
      final arguments = constant.arguments?.argumentList.arguments;
      if (arguments?.firstOrNull case final SimpleStringLiteral path) {
        paths.add(path.value);
        if (!files.contains(path.value)) {
          rule.reportAtNode(path, arguments: [path.value, appAssetName]);
        }
      }
    }
    for (final file in files.difference(paths)) {
      rule.reportAtToken(
        node.namePart.typeName,
        arguments: [file, 'pubspec.yaml'],
      );
    }
  }

  /// The paths of the files of the assets in `pubspec.yaml`, relative to the
  /// package root and separated by slashes.
  Set<String> _assetFiles() {
    final pubspec = root.getFile('pubspec.yaml');
    if (!pubspec.exists) {
      return {};
    }
    final assets = switch (loadYaml(pubspec.readAsStringSync())) {
      {'flutter': {'assets': final YamlList assets}} => assets,
      _ => const <Object?>[],
    };
    final context = root.provider.pathContext;
    final files = <File>[];
    for (final asset in assets) {
      final path = switch (asset) {
        final String path => path,
        {'path': final String path} => path,
        _ => null,
      };
      if (path == null) {
        continue;
      }
      final absolute = context.joinAll([root.path, ...path.split('/')]);
      if (path.endsWith('/')) {
        final folder = root.provider.getFolder(context.normalize(absolute));
        if (folder.exists) {
          files.addAll(folder.getChildren().whereType<File>());
        }
      } else {
        final file = root.provider.getFile(absolute);
        if (file.exists) {
          files.add(file);
        }
      }
    }
    return {
      for (final file in files)
        if (!file.shortName.startsWith('.'))
          context.split(context.relative(file.path, from: root.path)).join('/'),
    };
  }
}
