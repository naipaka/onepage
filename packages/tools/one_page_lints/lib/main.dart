import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';

import 'src/assists/add_macro_document_comment.dart';
import 'src/assists/add_macro_template_document_comment.dart';
import 'src/assists/wrap_with_macro_template_document_comment.dart';
import 'src/fixes/replace_with_clock_now.dart';
import 'src/rules/avoid_collection_equality_checks.dart';
import 'src/rules/avoid_consecutive_sliver_to_box_adapter.dart';
import 'src/rules/avoid_hardcoded_color.dart';
import 'src/rules/avoid_hardcoded_text.dart';
import 'src/rules/avoid_ignore_comments.dart';
import 'src/rules/avoid_optional_parameters_in_immutable_classes.dart';
import 'src/rules/avoid_shrink_wrap_in_list_view.dart';
import 'src/rules/avoid_single_child.dart';
import 'src/rules/include_all_fields.dart';
import 'src/rules/matching_asset_files.dart';
import 'src/rules/matching_json_keys.dart';
import 'src/rules/prefer_app_asset.dart';
import 'src/rules/prefer_clock_now.dart';
import 'src/rules/prefer_dedicated_media_query_methods.dart';
import 'src/rules/prefer_enum_over_sealed_class.dart';
import 'src/rules/prefer_space_between_elements.dart';
import 'src/rules/prefer_to_include_sliver_in_name.dart';
import 'src/rules/prefer_widget_class.dart';

/// The plugin that the analysis server loads.
final plugin = OnePageLintsPlugin();

/// {@template one_page_lints.OnePageLintsPlugin}
/// Registers the lint rules, fixes, and assists of One Page.
/// {@endtemplate}
class OnePageLintsPlugin extends Plugin {
  @override
  String get name => 'one_page_lints';

  @override
  void register(PluginRegistry registry) {
    registry
      ..registerLintRule(AvoidCollectionEqualityChecks())
      ..registerLintRule(AvoidConsecutiveSliverToBoxAdapter())
      ..registerLintRule(AvoidHardcodedColor())
      ..registerLintRule(AvoidHardcodedText())
      ..registerLintRule(AvoidIgnoreComments())
      ..registerLintRule(AvoidOptionalParametersInImmutableClasses())
      ..registerLintRule(AvoidShrinkWrapInListView())
      ..registerLintRule(AvoidSingleChild())
      ..registerLintRule(IncludeAllFields())
      ..registerLintRule(MatchingAssetFiles())
      ..registerLintRule(MatchingJsonKeys())
      ..registerLintRule(PreferAppAsset())
      ..registerLintRule(PreferClockNow())
      ..registerLintRule(PreferDedicatedMediaQueryMethods())
      ..registerLintRule(PreferEnumOverSealedClass())
      ..registerLintRule(PreferSpaceBetweenElements())
      ..registerLintRule(PreferToIncludeSliverInName())
      ..registerLintRule(PreferWidgetClass())
      ..registerFixForRule(PreferClockNow.code, ReplaceWithClockNow.new)
      ..registerAssist(AddMacroDocumentComment.new)
      ..registerAssist(AddMacroTemplateDocumentComment.new)
      ..registerAssist(WrapWithMacroTemplateDocumentComment.new);
  }
}
