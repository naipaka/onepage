import 'package:analysis_server_plugin/registry.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:one_page_lints/main.dart';
import 'package:one_page_lints/src/rules/prefer_clock_now.dart';
import 'package:test/test.dart';

void main() {
  test('the plugin registers the rules, the fix, and the assists', () {
    final registry = _RecordingRegistry();

    plugin.register(registry);

    expect(plugin.name, 'one_page_lints');
    expect(
      registry
          .calls(#registerLintRule)
          .map(
            (arguments) => (arguments.single! as AbstractAnalysisRule).name,
          ),
      unorderedEquals([
        'avoid_consecutive_sliver_to_box_adapter',
        'avoid_hardcoded_color',
        'avoid_hardcoded_text',
        'avoid_shrink_wrap_in_list_view',
        'avoid_single_child',
        'matching_json_keys',
        'prefer_clock_now',
        'prefer_dedicated_media_query_methods',
        'prefer_enum_over_sealed_class',
        'prefer_space_between_elements',
        'prefer_to_include_sliver_in_name',
        'prefer_widget_class',
      ]),
    );
    expect(
      registry.calls(#registerFixForRule).map((arguments) => arguments.first),
      [PreferClockNow.code],
    );
    expect(registry.calls(#registerAssist), hasLength(3));
  });
}

/// Records the registrations, whose generator types the registry keeps
/// private.
class _RecordingRegistry implements PluginRegistry {
  final _invocations = <Invocation>[];

  Iterable<List<Object?>> calls(Symbol member) => _invocations
      .where((invocation) => invocation.memberName == member)
      .map((invocation) => invocation.positionalArguments);

  @override
  void noSuchMethod(Invocation invocation) => _invocations.add(invocation);
}
