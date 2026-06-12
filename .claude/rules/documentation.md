---
paths:
  - "**/*.dart"
---

# Documentation & Comment Guidelines

## Doc Comments
- **Doc comments in English**: All `///` comments must be in English for OSS compatibility

## Documentation Comment Pattern (REQUIRED)
All public classes, widgets, and functions MUST use the `{@template}` and `{@macro}` pattern for documentation:

**Pattern Structure:**
1. Define template at class/widget level with `{@template package.ClassName}`
2. Provide detailed description of purpose and functionality
3. Close template with `{@endtemplate}`
4. Reference template at constructors/factories with `{@macro package.ClassName}`
5. Add constructor-specific details after `{@macro}` if needed
6. Document all fields/parameters inline

**For Regular Classes:**
```dart
/// {@template package.ClassName}
/// A detailed description of what this class does.
///
/// Additional context about usage, behavior, or important details.
/// {@endtemplate}
class ClassName {
  /// {@macro package.ClassName}
  ClassName({required this.field});

  /// {@macro package.ClassName}
  ///
  /// Additional details specific to this constructor.
  ClassName.named({required this.field});

  /// Description of this field.
  final String field;
}
```

**For Freezed Classes:**
```dart
/// {@template package.ModelName}
/// A detailed description of what this model represents.
///
/// Additional context about the model's purpose.
/// {@endtemplate}
@freezed
abstract class ModelName with _$ModelName {
  /// {@macro package.ModelName}
  const factory ModelName({
    /// Description of this field.
    required String field,
  }) = _ModelName;

  /// {@macro package.ModelName}
  ///
  /// Creates a [ModelName] instance from a JSON object.
  factory ModelName.fromJson(Map<String, Object?> json) =>
      _$ModelNameFromJson(json);
}
```

**For Widgets:**
```dart
/// {@template package.WidgetName}
/// A detailed description of what this widget displays.
///
/// Additional context about behavior and usage.
/// {@endtemplate}
class WidgetName extends StatelessWidget {
  /// {@macro package.WidgetName}
  const WidgetName({super.key, required this.data});

  /// The data to display.
  final String data;
}
```

**Examples from codebase:**
- `packages/features/haptics/lib/src/haptics.dart`
- `packages/core/prefs_client/lib/src/prefs_client.dart`
- `packages/features/exporter/lib/src/models/export_diary.dart`
- `packages/features/update_requester/lib/src/models/src/update_request.dart`

**IMPORTANT:** NEVER write class documentation without this pattern. The `{@macro}` reference allows documentation to be reused and ensures consistency across constructors.

## Comment Guidelines
- **Write comments to explain "WHY", not "WHAT"**
  - ✅ Good: Explain workarounds, technical constraints, non-obvious reasons
  - ❌ Bad: Describe what the code does (the code itself should be clear)
  - ❌ Bad: Explain obvious reasoning
- **Code should be self-documenting** through clear naming and structure
- **Examples**:
  ```dart
  // ❌ BAD - Explains what the code does
  // Scroll to selected date
  await scrollCalendarController.scrollToDate(date);

  // ❌ BAD - Obvious why
  // Check if user is null
  if (user == null) return;

  // ✅ GOOD - Explains why (workaround for specific issue)
  // Wrapped with TextFieldTapRegion to prevent keyboard hiding
  // when tapping text fields during scroll.
  return TextFieldTapRegion(child: TextField());

  // ✅ GOOD - Explains non-obvious technical reason
  // Use compute() to avoid blocking UI thread with large JSON parsing
  final data = await compute(parseJson, rawData);
  ```
