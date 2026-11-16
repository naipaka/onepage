import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';

import '../types.dart';
import 'matching_asset_files.dart';

/// {@template one_page_lints.PreferAppAsset}
/// Reports an asset path given to `Image.asset` or `AssetImage` that is not
/// the `path` of an `AppAsset` value.
///
/// `matching_asset_files` checks that the values of `AppAsset` match the asset
/// files, so a path taken from them always names a bundled file.
///
/// ```dart
/// Image.asset('assets/icon.png'); // LINT
/// Image.asset(AppAsset.icon.path); // OK
/// ```
/// {@endtemplate}
class PreferAppAsset extends AnalysisRule {
  /// {@macro one_page_lints.PreferAppAsset}
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  /// The code reported by this rule.
  static const code = LintCode(
    'prefer_app_asset',
    'The asset path is not taken from $appAssetName.',
    correctionMessage: "Try using the 'path' of an $appAssetName value.",
  );

  @override
  DiagnosticCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    registry.addInstanceCreationExpression(this, _Visitor(this));
  }
}

class _Visitor extends SimpleAstVisitor<void> {
  new(this.rule);

  final AnalysisRule rule;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final constructor = node.constructorName.element;
    final takesAssetPath =
        (isFlutterClass(constructor?.enclosingElement, 'Image') &&
            constructor?.name == 'asset') ||
        isFlutterClass(constructor?.enclosingElement, 'AssetImage');
    if (!takesAssetPath) {
      return;
    }
    final path = node.argumentList.arguments
        .where((argument) => argument is! NamedArgument)
        .firstOrNull
        ?.argumentExpression;
    if (path != null && !_isAppAssetPath(path)) {
      rule.reportAtNode(path);
    }
  }

  /// Whether [expression] reads the `path` of an `AppAsset` value.
  static bool _isAppAssetPath(Expression expression) {
    final element = switch (expression) {
      PropertyAccess(:final propertyName) => propertyName.element,
      PrefixedIdentifier(:final identifier) => identifier.element,
      _ => null,
    };
    return element is GetterElement &&
        element.name == 'path' &&
        element.enclosingElement is EnumElement &&
        element.enclosingElement.name == appAssetName;
  }
}
