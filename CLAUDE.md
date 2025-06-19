# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

One Page is a Flutter diary app with a unique "one page only" concept. It uses a monorepo architecture with Melos for package management and is organized into feature-based packages.

## Development Setup

Initial setup:
```bash
make
```
This installs FVM, Melos, and other required tools.

For worktree setup:
```bash
make worktree
```

## Core Commands

### Testing
```bash
melos run test              # Run all tests
melos run test:cov          # Run tests with coverage
```

### Code Generation
```bash
melos run gen               # Generate code (build_runner)
melos run gen:watch         # Watch mode for code generation
melos run slang             # Generate i18n translations
```

### Linting and Formatting
```bash
melos run custom_lint       # Run custom lints
melos run fix               # Apply dart fixes and custom lint fixes
```

### Build
```bash
melos run build:android:prod    # Build Android production
melos run upload:ios:prod       # Build iOS production
```

### Database
```bash
melos run drift:migrations  # Generate drift migrations
```

## Architecture

### Package Structure
- **app/**: Main application package with UI, routing, and app-level providers
- **core/**: Shared utilities and foundational packages
  - **db_client/**: Drift-based SQLite database client
  - **i18n/**: Slang-based internationalization (English/Japanese)
  - **provider_utils/**: Riverpod utilities and common providers
  - **theme/**: App theming and design system
  - **utils/**: General utility functions
  - **widgets/**: Shared UI components (domain-independent only)
- **features/**: Domain-specific functionality
  - **backup/**: Data backup and restore
  - **diary/**: Core diary functionality
  - **scroll_calendar/**: Calendar widget
  - **update_requester/**: App update management

### State Management
- Uses Riverpod with code generation (`@riverpod` annotation)
- Providers are generated using `riverpod_generator`
- **Widget Selection**:
  - **HookWidget**: Use for local state management with `useState`, `useEffect`, etc.
  - **HookConsumerWidget**: Use when you need both hooks and Riverpod providers
  - **ConsumerWidget**: Use when you only need Riverpod providers (no local state)
  - **StatelessWidget**: Use for widgets without any state
- **ref.watch**: Use ONLY in build methods for reactive updates
- **ref.read**: Use in event handlers/onPressed for one-time reads
- For local state management, prefer `HookWidget` with `useState` over `StatefulWidget`

### Database
- SQLite with Drift ORM
- Schema versioning with migrations
- Database client is provided through dependency injection

### Internationalization
- Slang framework for type-safe translations
- Supports English (`app_en.yaml`) and Japanese (`app_ja.yaml`)
- All user-facing text must be internationalized

## Development Guidelines

### Widget Development
- **Class Widgets ONLY**: Functional widgets are strictly prohibited
  - Use `StatelessWidget`, `StatefulWidget`, `ConsumerWidget`, `HookConsumerWidget`, `HookWidget`
  - NO `_buildSomething` methods - create separate class widgets instead
  - Better performance optimization, bug prevention, and testability
- **Static methods**: Use `Widget.show()` inside classes, not global functions
- **Code organization**: No global private functions - use class methods or inline code
- **NO Widget Variables**: NEVER use `final child = Widget()` - return widgets directly

### Widget Component Design Rules
- **Component Padding**: NEVER add padding/margin inside reusable components
  - Components should NOT contain internal padding or margins
  - Padding/margin should be added by the CALLER of the component
  - This ensures components remain flexible and reusable
  ```dart
  // ❌ BAD - Component contains internal padding
  class MyComponent extends StatelessWidget {
    Widget build(BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16), // DON'T DO THIS
        child: Text('Content'),
      );
    }
  }
  
  // ✅ GOOD - Caller controls padding
  class MyComponent extends StatelessWidget {
    Widget build(BuildContext context) {
      return Text('Content'); // Clean component
    }
  }
  
  // Usage with padding controlled by caller
  Padding(
    padding: EdgeInsets.all(16),
    child: MyComponent(),
  )
  ```

- **Padding Widget Usage**: Use `Padding` widget, NOT `Container` for padding-only purposes
  - `Container` should only be used when you need decoration, constraints, or multiple properties
  - Use `Padding` when you only need to add padding
  ```dart
  // ❌ BAD - Using Container for padding only
  Container(
    padding: EdgeInsets.all(16),
    child: widget,
  )
  
  // ✅ GOOD - Using Padding for padding only
  Padding(
    padding: EdgeInsets.all(16),
    child: widget,
  )
  ```

### Package Dependencies
- **core/widgets/**: Must NEVER depend on i18n package
  - Use `intl` package for localization or pass strings as parameters
  - Only domain-independent, reusable UI components
- **features/[domain]/**: Can depend on core packages but not other feature packages
- **Dependency injection**: Pass required data/callbacks as widget parameters

### Error Handling & Validation
- **Range validation**: Always validate date ranges and scroll positions
- **Context mounting**: Check `context.mounted` before async operations
- **ScrollCalendar limits**: VerticalScrollCalendar has limited date range
  - Check if target date is within loaded range before `scrollToDate()`
  - Use `loadMoreOlder()` to expand range if needed
  - Use try-catch blocks for scroll operations

### Testing
- **100% Test Coverage Required**: All packages except app/ and widgets/ must achieve 100% test coverage
  - Verify coverage with `flutter test --coverage` in each package
  - Check lcov.info: LF (Lines Found) = LH (Lines Hit)
  - Add comprehensive tests for all new functionality
- Use Mockito for mocking (`@GenerateMocks` annotation)
- Mock files in `test/utils/mock_*.dart`
- Platform channel mocks use `TestDefaultBinaryMessengerBinding`
- Always clean up mocks in `tearDown`

### Code Generation Dependencies
Run `melos run gen` after changes to:
- Riverpod providers with `@riverpod`
- Drift database tables
- i18n translation files
- Freezed data classes

### Documentation Standards
- **Doc comments in English**: All `///` comments must be in English for OSS compatibility
- **Complete error checking**: Always verify ALL compilation errors before claiming completion
  - Use `mcp__ide__getDiagnostics` to check for actual compilation errors
  - Never claim completion without verifying zero diagnostics

### Environment Configuration
- Environment variables in `packages/app/dart_defines/`
- Firebase configuration files for dev/prod environments
- Use `--dart-define-from-file` for builds

## Text Styling Guidelines

### Use App Text Classes (REQUIRED)
- **NEVER** use `TextStyle` directly - use semantic text classes from `packages/core/theme/lib/src/widgets/src/app_text.dart`
- **NEVER** specify `fontFamily` - use default fonts only
- **NEVER** specify `fontSize` directly - use predefined text classes

### Available Text Classes:
- **Display**: `DisplayLargeText`, `DisplayMediumText`, `DisplaySmallText`
- **Headline**: `HeadlineLargeText`, `HeadlineMediumText`, `HeadlineSmallText`
- **Title**: `TitleLargeText`, `TitleMediumText`, `TitleSmallText`
- **Body**: `BodyLargeText`, `BodyMediumText`, `BodySmallText`
- **Label**: `LabelLargeText`, `LabelMediumText`, `LabelSmallText`

### Text Class Properties:
All text classes support:
- `color` - Text color (only specify when different from theme default)
- `fontWeight` - Font weight override
- `textAlign` - Text alignment
- `maxLines` - Maximum lines with ellipsis
- `indent` - Left padding
- `height` - Line height

### Color Usage in Text Widgets:
- **Default behavior**: Text widgets automatically use appropriate theme colors (`onSurface`, `onPrimary`, etc.)
- **Only specify `color`** when you need a different color (e.g., `alpha: 0.6` for subtle text)
- **Available colors** defined in `packages/core/theme/lib/src/style/src/light_color_scheme.dart` and `dark_color_scheme.dart`

### Example Usage:
```dart
// ✅ Correct - Default theme colors are applied automatically
BodyLargeText(
  'Settings',
  fontWeight: FontWeight.w700,
)

// ✅ Correct - Only specify color when you need a different color
LabelSmallText(
  'Subtitle',
  color: colorScheme.onSurface.withValues(alpha: 0.6),
)

// ❌ Wrong - Don't use TextStyle directly
Text(
  'Settings',
  style: TextStyle(
    fontSize: 16,
    fontFamily: 'SF Pro Text',
    color: colorScheme.onSurface,
  ),
)

// ❌ Wrong - Don't specify onSurface explicitly unless needed
BodyLargeText(
  'Settings',
  color: colorScheme.onSurface, // Unnecessary - this is the default
)
```

## Theme and Color Guidelines

### Color Usage
- **NEVER** use hardcoded colors like `Color(0xFF123456)`
- **ALWAYS** use `colorScheme` colors: `colorScheme.primary`, `colorScheme.onSurface`, etc.
- Access via `context.colorScheme` extension from theme package

### AppBar Styling
```dart
AppBar(
  backgroundColor: colorScheme.surfaceContainerLowest,
  titleTextStyle: context.textTheme.headlineSmall, // Uses theme default colors
)
```

## Internationalization Requirements

### Hardcoded Text Prevention
- **NEVER** use hardcoded Japanese text in Dart files
- **ALWAYS** add strings to `packages/core/i18n/lib/src/i18n/app_ja.yaml` and `app_en.yaml`
- Use `context.t.section.key` to access translations
- Run `dart run slang` in i18n package after updating YAML files

### Translation Structure:
```yaml
# app_ja.yaml / app_en.yaml
section:
  title: "Title Text"
  description: "Description Text"
  subsection:
    item: "Item Text"
```

### Usage:
```dart
// Access translations
Text(context.t.section.title)
Text(context.t.section.subsection.item)
```

## Example HookWidget Usage:
```dart
class MyPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final isEnabled = useState(true);
    final controller = useTextEditingController();
    
    return Scaffold(
      body: Switch(
        value: isEnabled.value,
        onChanged: (value) => isEnabled.value = value,
      ),
    );
  }
}
```

## Quality Assurance Workflow

### Before Completing Any Task:
1. Run `dart analyze` - must show "No issues found!"
2. Run `dart run custom_lint` - must show "No issues found!"
3. Verify no hardcoded Japanese text warnings
4. Verify no hardcoded color warnings
5. Verify all TextStyle usage is replaced with app text classes

### Code Generation Commands:
```bash
# After route changes
cd packages/app && dart run build_runner build --delete-conflicting-outputs

# After i18n changes
cd packages/core/i18n && dart run slang
```

## Language Requirements

**STRICT**: Match response language to input language:
- English input → English response
- Japanese input → Japanese response
- No exceptions allowed

## Development Workflow

1. Use FVM for Flutter version management
2. Run `melos run gen` after structural changes
3. Run tests before committing
4. Use `melos run custom_lint` to check code quality
5. Follow package dependency rules (features don't depend on each other)
6. **ALWAYS** check for and resolve all linting warnings before considering a task complete

## Learning and Documentation Protocol

**IMPORTANT**: When discovering new patterns, conventions, or solutions while working on this codebase:

1. **Immediately document findings** in this CLAUDE.md file under the appropriate section
2. **Add new sections** if the discovery doesn't fit existing categories
3. **Include both "do" and "don't" examples** for clarity
4. **Document the reasoning** behind conventions when possible
5. **Update this file proactively** - don't wait to be asked

This ensures consistent code quality and helps maintain institutional knowledge across all future development work.