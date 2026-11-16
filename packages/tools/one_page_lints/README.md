# one_page_lints

An analyzer plugin with the lint rules, fixes, and assists of One Page.

## Lint rules

| Rule | Reports |
|---|---|
| `avoid_consecutive_sliver_to_box_adapter` | A `SliverToBoxAdapter` that follows another one in a list |
| `avoid_hardcoded_color` | Colors written in code outside a `ColorScheme`, except `Colors.transparent` |
| `avoid_hardcoded_text` | String literals with text in `lib`, in any language, except values for machines and the documented constants of `UntranslatedTexts` |
| `avoid_shrink_wrap_in_list_view` | `shrinkWrap` of a `ListView` inside a `ListView`, `Column`, or `Row` |
| `avoid_single_child` | A widget that lays out a list of children, such as `Column` or `ListView`, given one child at most |
| `matching_json_keys` | A JSON key that only one of `fromJson` and `toJson` uses |
| `prefer_clock_now` | `DateTime.now()` and `DateTime.timestamp()` |
| `prefer_dedicated_media_query_methods` | `MediaQuery.of` and `MediaQuery.maybeOf`, and `.width` or `.height` of `MediaQuery.sizeOf` |
| `prefer_enum_over_sealed_class` | A sealed class whose direct subtypes are all classes with no instance fields, type parameters, subclasses, or other supertypes |
| `prefer_space_between_elements` | No blank line between fields, constructors, and the `build` method |
| `prefer_to_include_sliver_in_name` | A widget that returns a sliver without "Sliver" in its name |
| `prefer_widget_class` | A function, a method, or a getter that returns a widget |

`avoid_hardcoded_color` and `prefer_widget_class` skip the test directories. `avoid_hardcoded_text` checks only `lib`, and skips generated files and the packages in `packages/tools`.

## Fix and assists

- `prefer_clock_now` has a fix that replaces the call with `clock.now()` of package:clock.
- The assists add the `{@template}` and `{@macro}` documentation comments that `.claude/rules/documentation.md` asks for:
  - Add a macro template documentation comment, on the name of a class, an enum, a mixin, an extension type, or a type alias.
  - Wrap with a macro template documentation comment, on an existing documentation comment.
  - Add a macro documentation comment, on the signature of a constructor or a method.

## Usage

The root `analysis_options.yaml` loads the plugin by path and turns on each rule:

```yaml
plugins:
  one_page_lints:
    path: packages/tools/one_page_lints
    diagnostics:
      avoid_hardcoded_text: true
```

To ignore a rule, prefix it with the plugin name:

```dart
// ignore: one_page_lints/avoid_hardcoded_text
```

## Tests

The tests use test_reflective_loader, which needs dart:mirrors, so run them with `dart test`. `fvm dart run melos run test` does this for the Dart packages.

## License

The lint rules, the fix, and the assists are based on altive_lints_plugin. See [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES) for its license.
