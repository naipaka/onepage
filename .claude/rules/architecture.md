---
paths:
  - "packages/**"
---

# Architecture Guidelines

## Package Placement Guidelines

When deciding whether code belongs in `core/widgets/` or `features/`, use **responsibility-based criteria** rather than usage-based criteria.

### widgets package (core/widgets/)

Place code here if it meets **ALL** of the following conditions:

1. ✅ **Domain-independent**: Contains no domain knowledge (diary, backup, etc.)
2. ✅ **Minimal dependencies**: Depends only on Flutter standard libraries + generic packages (toastification, intl, etc.)
3. ✅ **Pure UI or UI utilities**: Simple UI components or UI-related utility functions

**Examples**: `DashedDivider`, `Toast`, `TextHistoryActionButton`, `KeyboardToolbar`, `CenterLoadingIndicator`

### features package (features/xxx/)

Place code here if it meets **ANY** of the following conditions:

1. ❌ **Contains domain knowledge**: Specific to diary, backup, or other feature domains
2. ❌ **Specific external dependencies**: Depends on specialized packages (photo_manager, app_settings, etc.)
3. ❌ **Complex business logic**: Contains complex state management, business logic, or workflows

**Examples**: `PhotoSelector` (permission management + pagination + photo_manager dependency)

### Decision Rule

When in doubt, ask: **"Can this widget/code be used as-is in a completely different app (not a diary app)?"**

- If **Yes** → `core/widgets/`
- If **No** → `features/`

**Important**: Use responsibility-based criteria, not usage-based criteria. Even if a widget is currently used in only one place, if it's domain-independent and reusable, it belongs in `core/widgets/`.

## Package Dependencies

- **core/widgets/**: Must NEVER depend on i18n package
  - Use `intl` package for localization or pass strings as parameters
  - Only domain-independent, reusable UI components
- **features/[domain]/**: Can depend on core packages but not other feature packages
- **Dependency injection**: Pass required data/callbacks as widget parameters

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
  - packages/core/notification_client # Add new packages here
  - packages/core/prefs_client
  # ... other packages

# Package pubspec.yaml
name: notification_client
resolution: workspace # Required for workspace packages
```

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
- **Version consistency**: Match lint versions across all packages
