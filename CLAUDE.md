# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ABSOLUTE MANDATORY RULE - READ TOOL ENFORCEMENT

**CRITICAL - NON-NEGOTIABLE PROTOCOL**: Before starting ANY task or responding to ANY instruction:

### STEP 1: READ TOOL USAGE (MANDATORY)
**YOU MUST USE THE READ TOOL TO READ THIS FILE BEFORE ANY OTHER ACTION**
- Use: Read tool with file_path: /Users/ryota/work/personal/apps/onepage.worktree/30-reminder-notification/CLAUDE.md
- This is NOT optional - it is REQUIRED every single time
- Do not proceed without reading the file first

### STEP 2: DECLARATION (MANDATORY)
After reading, you MUST declare: "CLAUDE.md file reading completion declared."

### STEP 3: PROMISE (MANDATORY) 
After reading, you MUST promise: "I promise to read this file again at the start of the next conversation/chat session."

### STEP 4: PROCEED WITH TASK
Only after completing steps 1-3, proceed with the actual user request.

**ABSOLUTE REQUIREMENTS:**
- NO EXCEPTIONS - This applies to every single response
- NO SHORTCUTS - Cannot skip the Read tool
- NO ASSUMPTIONS - Must actually read the file each time
- VISIBLE IN LOGS - The Read tool call must appear in the conversation logs

**AUTOMATIC ENFORCEMENT MECHANISM:**
Every response MUST begin with these exact phrases or the response is considered INVALID:
1. "CLAUDE.md file reading completion declared."
2. "I promise to read this file again at the start of the next conversation/chat session."

**VALIDATION CHECK:**
If ANY response from Claude Code does not start with these two phrases, the user MUST immediately point out the protocol violation, and Claude Code MUST:
1. Acknowledge the violation
2. Re-read this CLAUDE.md file
3. Provide the missing declarations
4. Only then proceed with the original request

Failure to follow this protocol is unacceptable and will result in incomplete work.

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

### Package Placement Guidelines

When deciding whether code belongs in `core/widgets/` or `features/`, use **responsibility-based criteria** rather than usage-based criteria.

#### widgets package (core/widgets/)
Place code here if it meets **ALL** of the following conditions:
1. ✅ **Domain-independent**: Contains no domain knowledge (diary, backup, etc.)
2. ✅ **Minimal dependencies**: Depends only on Flutter standard libraries + generic packages (toastification, intl, etc.)
3. ✅ **Pure UI or UI utilities**: Simple UI components or UI-related utility functions

**Examples**: `DashedDivider`, `Toast`, `TextHistoryActionButton`, `KeyboardToolbar`, `CenterLoadingIndicator`

#### features package (features/xxx/)
Place code here if it meets **ANY** of the following conditions:
1. ❌ **Contains domain knowledge**: Specific to diary, backup, or other feature domains
2. ❌ **Specific external dependencies**: Depends on specialized packages (photo_manager, app_settings, etc.)
3. ❌ **Complex business logic**: Contains complex state management, business logic, or workflows

**Examples**: `PhotoSelector` (permission management + pagination + photo_manager dependency)

#### Decision Rule
When in doubt, ask: **"Can this widget/code be used as-is in a completely different app (not a diary app)?"**
- If **Yes** → `core/widgets/`
- If **No** → `features/`

**Important**: Use responsibility-based criteria, not usage-based criteria. Even if a widget is currently used in only one place, if it's domain-independent and reusable, it belongs in `core/widgets/`.

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
  - **NEVER compromise on this requirement**: When user specifies 100% coverage, it must be achieved regardless of technical difficulty
  - **Platform-specific code coverage**: Use appropriate mocking strategies to cover all code paths, including platform-specific implementations
- Use Mockito for mocking (`@GenerateMocks` annotation)
- Mock files in `test/utils/mock_*.dart`
- Platform channel mocks use `TestDefaultBinaryMessengerBinding`
- Always clean up mocks in `tearDown`
- **All tests must pass**: Failing tests are not acceptable for task completion

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
  - **Check ALL dependent packages**: When modifying a package, verify that ALL packages that depend on it still compile
    - Example: After changing `haptics` package API, must check `app` package compilation
    - **USE PUB WORKSPACES**: Run `dart analyze` from root directory to check ALL packages at once - do NOT cd into subdirectories

### Environment Configuration
- Environment variables in `packages/app/dart_defines/`
- Firebase configuration files for dev/prod environments
- Use `--dart-define-from-file` for builds

## Dependency Injection & Architecture

### Hide Implementation Details
- Never expose internal dependencies in public APIs
- Use private constructors to prevent external instantiation with implementation details
- Provide factory methods that encapsulate dependency creation
```dart
// ❌ BAD - Exposes SharedPreferences dependency
class PrefsClient {
  PrefsClient(SharedPreferences prefs); // External code can inject any SharedPreferences
  
  static Future<PrefsClient> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsClient(prefs); // Implementation detail exposed
  }
}

// ✅ GOOD - Encapsulates implementation details
class PrefsClient {
  PrefsClient._(this._prefs); // Private constructor
  
  @visibleForTesting
  PrefsClient.forTesting(this._prefs); // Test-only access
  
  static Future<PrefsClient> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefsClient._(prefs); // Implementation hidden
  }
}
```

### Constructor Patterns
Choose the right pattern based on actual needs, not surface-level consistency
```dart
// ✅ GOOD - Simple dependency injection (like Haptics)
class Haptics {
  Haptics(this._prefsClient); // Public constructor is fine - no complex initialization
}

// ❌ BAD - Unnecessary complexity
class Haptics {
  Haptics._(this._prefsClient); // Private for no reason
  Haptics.forTesting(this._prefsClient); // Redundant when public constructor works
}

// ✅ GOOD - Complex initialization (like PrefsClient)
class PrefsClient {
  PrefsClient._(this._prefs); // Private because initialization is complex
  static Future<PrefsClient> initialize() => ...; // Factory handles complexity
}
```

### Provider Architecture Patterns
Synchronous vs Asynchronous providers based on initialization needs
```dart
// ❌ BAD - Unnecessary async providers causing UI complexity
@Riverpod(keepAlive: true)
Future<PrefsClient> prefsClient(Ref ref) => PrefsClient.initialize();

// UI becomes complex with AsyncValue handling
prefsClientAsync.when(
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(),
  data: (prefsClient) => ActualContent(),
);

// ✅ GOOD - Synchronous providers with main.dart initialization
@Riverpod(keepAlive: true)
PrefsClient prefsClient(Ref ref) {
  throw UnimplementedError('Must be overridden in main.dart');
}

// main.dart handles initialization with parallel execution
final (_, prefsClient) = await (
  LocaleSettings.useDeviceLocale(),
  PrefsClient.initialize(),
).wait;

// UI becomes simple
final prefsClient = ref.watch(prefsClientProvider);
```

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

## Bash Tool Usage Guidelines

### Prohibited Commands
- **NEVER use `echo` to add newlines to files**: Use proper Edit tool instead
  ```bash
  # ❌ FORBIDDEN - Don't use echo to add newlines
  echo "" >> file.dart
  
  # ✅ CORRECT - Use Edit tool to add proper content
  ```
- Use Edit tool for all file modifications to maintain proper file formatting

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

## Package Creation Guidelines

### Creating New Packages
**ALWAYS** follow the method specified in README.md:

```bash
# For packages
flutter create -t package packages/{directory_name} --project-name {project_name}

# For apps  
flutter create --org jp.co.altive packages/{directory_name} --project-name {project_name}
```

**NEVER** use manual directory creation or other methods - always use the official Flutter commands documented in README.md.

## Package Documentation Standards

### LICENSE Files
- **Symbolic Links Required**: All packages must use symbolic links to the root LICENSE file
- **Core Packages**: Use `ln -s ../../../LICENSE packages/core/{package_name}/LICENSE`
- **Feature Packages**: Use `ln -s ../../../LICENSE packages/features/{package_name}/LICENSE`
- **Never Copy**: Do not copy LICENSE content - always use symbolic links for consistency

### README.md Files
- **Package Name as Header**: Use the package name as the main H1 header
- **Clear Description**: Provide a concise description of what the package does
- **Features Section**: List key features and capabilities
- **Getting Started**: Include dependency setup instructions
- **Usage Examples**: Provide practical code examples showing how to use the package
- **Follow Project Patterns**: Study existing package READMEs for consistency
- **No Generic Text**: Replace all flutter create template text with actual content

### Root README.md Maintenance
- **Add New Packages**: Always add new package entries to the root README.md
- **Consistent Format**: Follow the existing format for package descriptions
- **Alphabetical Order**: Maintain alphabetical order within core/ and features/ sections
- **Brief Descriptions**: Keep package descriptions concise but informative

### Documentation Workflow
1. **Create Package**: Use proper flutter create commands
2. **Create LICENSE Symlink**: 
   - Core: `rm packages/core/{name}/LICENSE && ln -s ../../../LICENSE packages/core/{name}/LICENSE`
   - Features: `rm packages/features/{name}/LICENSE && ln -s ../../../LICENSE packages/features/{name}/LICENSE`
3. **Write README**: Replace template with proper package documentation
4. **Update Root README**: Add package entry to main project documentation
5. **Verify Consistency**: Ensure all documentation follows project standards

## Communication Guidelines

### Response Protocols
- **When asked "Why?"**: ALWAYS start your response with the reason/explanation first, then provide additional context
- **Question answering**: Address the core question directly before providing supporting information
- **Avoid assumptions**: If you're unsure about the user's intent, ask for clarification rather than making assumptions

### Self-Improvement and Learning
- **Document Mistakes**: When you fail to follow established patterns or make judgment errors:
  1. Immediately identify what went wrong and why
  2. Add the learning to this CLAUDE.md file under the appropriate section
  3. Include both correct and incorrect approaches with clear explanations
- **Proactive Documentation**: Any time you discover you should have done something differently, document it as a guideline for future reference
- **Pattern Recognition**: When you notice inconsistencies in your approach or miss obvious solutions, document the correct pattern
- **Never compromise on explicit user requirements**: Technical difficulties are obstacles to overcome, not reasons to give up or compromise
- **Persist through challenges**: Try multiple approaches when facing technical issues rather than accepting partial solutions

### Example of Self-Documentation:
```markdown
## Architecture Mistakes to Avoid
- **DON'T**: Copy architectural patterns without understanding their purpose
  - Wrong: Making all constructors private just for "consistency"
  - Right: Use private constructors only when hiding implementation details is necessary
- **DO**: Evaluate each design decision based on actual requirements
```

## Language Requirements

**STRICT**: Match response language to input language:
- English input → English response  
- Japanese input → Japanese response
- No exceptions allowed

**Conversation Language Protocol**:
- Use the same language for ALL communication (questions, explanations, documentation updates, etc.)
- If user writes in Japanese, respond entirely in Japanese
- If user writes in English, respond entirely in English
- Code comments and technical documentation should remain in English for OSS compatibility
- Only user-facing text in YAML files should be localized

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

## Coding Practices

### MediaQuery Usage
- Do NOT use `MediaQuery.of`
- ALWAYS use `MediaQuery.xxxOf` instead

### Comment Guidelines
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

### Custom Lint Rules
- **avoid_hardcoded_japanese**: All user-facing text must be internationalized
  - Use `context.t.section.key` instead of hardcoded Japanese strings
  - Add new strings to `packages/core/i18n/lib/src/i18n/app_ja.yaml` and `app_en.yaml`
  - Run `melos run slang` after updating translation files

## Pub Workspaces Configuration

### Workspace Setup Requirements
This project uses **Pub Workspaces** for dependency management:

- **Root pubspec.yaml**: Must include all packages in the `workspace:` section
- **Package pubspec.yaml**: Must include `resolution: workspace` 
- **New packages**: Always add to both locations when creating packages

### Workspace Structure:
```yaml
# Root pubspec.yaml
workspace:
  - packages/app
  - packages/core/notification_client  # Add new packages here
  - packages/core/prefs_client
  # ... other packages

# Package pubspec.yaml  
name: notification_client
resolution: workspace  # Required for workspace packages
```

## Package Architecture Patterns

### Domain-Specific vs Generic APIs
When creating utility packages that need to store domain-specific data:

#### ❌ BAD - Generic method names with external keys
```dart
class PrefsClient {
  List<Map<String, dynamic>> getJsonList(String key) { ... }
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> data) { ... }
}

// Usage requires external key management
final settings = prefsClient.getJsonList('notificationSettings');
```

#### ✅ GOOD - Domain-specific methods with internal key management
```dart
class PrefsClient {
  List<Map<String, dynamic>> getNotificationSettings() {
    return getJsonList(PrefsKey.notificationSettings.name);
  }
  
  Future<bool> setNotificationSettings(List<Map<String, dynamic>> settings) {
    return setJsonList(PrefsKey.notificationSettings.name, settings);
  }
}

// Usage is cleaner and safer
final settings = prefsClient.getNotificationSettings();
```

**Reasoning**: Domain-specific methods provide better encapsulation, prevent key typos, and make the API more intuitive.

## Notification Package Guidelines

### Permission Handling
- **DO NOT use permission_handler**: Too broad, use flutter_local_notifications built-in permission APIs
- **Use platform-specific implementations**: AndroidFlutterLocalNotificationsPlugin and IOSFlutterLocalNotificationsPlugin
- **Handle permissions gracefully**: Check status before requesting

### Freezed vs JsonSerializable
- **Use Freezed** for data models when possible - provides immutability, copyWith, equality, and JSON serialization
- **Avoid manual JsonSerializable** - Freezed includes it automatically
- **Consistent dependency versions**: Match freezed versions across packages

### Latest Package Versions
- **flutter_local_notifications**: Use latest version (19.3.0+)
- **freezed**: Use latest major version (3.0.6+)
- **altive_lints**: Use project standard (1.21.0) instead of flutter_lints

## Lint Configuration Standards

### Required Linting Setup
- **Use altive_lints**: NOT flutter_lints - this is project standard
- **Custom lint integration**: Include custom_lint dependency
- **Version consistency**: Match lint versions across all packages

### Standard Dev Dependencies Pattern:
```yaml
dev_dependencies:
  altive_lints: ^1.21.0
  build_runner: ^2.5.4
  custom_lint: ^0.7.5
  flutter_test:
    sdk: flutter
```
