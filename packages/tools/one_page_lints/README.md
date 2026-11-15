# one_page_lints

An analyzer plugin with the lint rules, fixes, and assists of One Page.

## Lint rules

| Rule | Reports |
|---|---|
| `avoid_consecutive_sliver_to_box_adapter` | A `SliverToBoxAdapter` that follows another one in a list |
| `avoid_hardcoded_color` | Colors written in code outside a `ColorScheme`, except `Colors.transparent` |
| `avoid_hardcoded_japanese` | String literals with Japanese text |
| `avoid_shrink_wrap_in_list_view` | `shrinkWrap` of a `ListView` inside a `ListView`, `Column`, or `Row` |
| `avoid_single_child` | A widget for many children, such as `Column`, given one child at most |
| `prefer_clock_now` | `DateTime.now()` and `DateTime.timestamp()` |
| `prefer_dedicated_media_query_methods` | `MediaQuery.of` and `MediaQuery.maybeOf`, and `.width` or `.height` of `MediaQuery.sizeOf` |
| `prefer_space_between_elements` | No blank line between fields, constructors, and the `build` method |
| `prefer_to_include_sliver_in_name` | A widget that returns a sliver without "Sliver" in its name |
| `prefer_widget_class` | A function, a method, or a getter that returns a widget |

`avoid_hardcoded_color`, `avoid_hardcoded_japanese`, and `prefer_widget_class` skip the test directories.

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
      avoid_hardcoded_japanese: true
```

To ignore a rule, prefix it with the plugin name:

```dart
// ignore: one_page_lints/avoid_hardcoded_japanese
```

## Tests

The tests use test_reflective_loader, which needs dart:mirrors, so run them with `dart test`. `fvm dart run melos run test` does this for the Dart packages.

## License

The lint rules, the fix, and the assists are based on altive_lints_plugin. See [THIRD_PARTY_NOTICES](THIRD_PARTY_NOTICES) for its license.
