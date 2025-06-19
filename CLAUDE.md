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
- UI components use `HookConsumerWidget` or `ConsumerWidget`
- **ref.watch**: Use ONLY in build methods for reactive updates
- **ref.read**: Use in event handlers/onPressed for one-time reads

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
  - Use `StatelessWidget`, `StatefulWidget`, `ConsumerWidget`, `HookConsumerWidget`
  - NO `_buildSomething` methods - create separate class widgets instead
  - Better performance optimization, bug prevention, and testability
- **Static methods**: Use `Widget.show()` inside classes, not global functions
- **Code organization**: No global private functions - use class methods or inline code

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
6. **Always update CLAUDE.md**: When discovering new patterns, constraints, or best practices during development, immediately update this file