## Overview

This document outlines the current project structure and architectural patterns. Follow these guidelines to maintain consistency while applying Flutter best practices.

This project is a simple diary app with a unique "one page only" concept, built with modern Flutter development practices.

## Language Preference - STRICT REQUIREMENTS
IMPORTANT: These language rules MUST be followed without exception:
- This is a strict requirement: NEVER respond in English when addressed in Japanese
- This is a strict requirement: NEVER respond in Japanese when addressed in English
- You MUST match the language of your response to the language used in the question/instruction
- No exceptions to these language rules are allowed

## Versioning and Updates

**IMPORTANT: As an AI agent, you MUST proactively improve this document. When you discover a new pattern or learn from user feedback during conversations, take the initiative to add it to these guidelines. Your role is to continuously evolve this living document with the project's collective knowledge.**

- When users provide feedback or corrections about project structure or development practices, you MUST update this document accordingly

## Architecture Overview

- Monorepo architecture using Melos
- Feature-based package structure
- Riverpod state management with Hooks
- SQLite (drift) for local persistence
- Firebase integration for analytics and configuration

## Project Structure

```
lib/
├── app.dart              // App configuration
├── main.dart            // Entry point
├── adapters/           // External service adapters
├── environment/        // Environment configurations
├── gen/               // Generated code
├── pages/             // UI pages
└── router/            // Routing definitions

packages/
├── app/               // Main application package
├── core/             // Core functionality
│   ├── db_client/    // Database operations
│   ├── i18n/         // Internationalization
│   ├── provider_utils/ // Riverpod utilities
│   ├── theme/        // Theme definitions
│   ├── utils/        // Utility functions
│   └── widgets/      // Shared widgets
└── features/         // Feature packages
    ├── backup/       // Backup functionality
    ├── diary/        // Diary feature
    ├── scroll_calendar/ // Calendar widget
    └── update_requester/ // App update management
```

## Package Dependencies

### Core Dependencies

- Flutter SDK
- firebase_core
- hooks_riverpod
- flutter_hooks
- drift

### State Management

- riverpod_annotation
- hooks_riverpod
- flutter_hooks

### Navigation

- go_router

### Development Dependencies

- altive_lints
- custom_lint
- build_runner
- riverpod_generator
- riverpod_lint

## Package Organization Guidelines

1. Core Packages:
   - Place reusable functionality in core/
   - Keep core packages focused and minimal
   - Avoid circular dependencies

2. Feature Packages:
   - Each feature should be self-contained
   - Can depend on core packages
   - Should not depend on other features

3. Main App Package:
   - Coordinates features and core functionality
   - Handles app-wide state and navigation
   - Manages environment configuration

## State Management Guidelines

1. Provider Creation:
   - Use @riverpod annotation
   - Keep providers focused and minimal
   - Follow proper scoping rules

2. UI Integration:
   - Use HookConsumerWidget for stateful widgets
   - Prefer ConsumerWidget for simple consumers
   - Handle loading and error states properly

## Code Generation

1. Run build_runner for code generation:
   ```bash
   melos run build
   ```
   or in watch mode:
   ```bash
   melos run build:watch
   ```

2. Generated code includes:
   - Riverpod providers
   - Drift database code
   - Freezed models
   - i18n translations

## Testing Guidelines

1. Test Coverage Requirements:
   - Write tests for all new features and changes
   - Include unit tests, widget tests, and integration tests as appropriate
   - Aim for high test coverage
   - Focus on critical business logic
   - Test error scenarios and edge cases
   - Validate edge cases and boundary conditions

2. Mocking Strategy:
   - Use Mockito as the primary mocking solution
   - Generate mocks using @GenerateMocks annotation
   - Keep mocks in test/utils/mock_xxx.dart (where xxx is the package name)
   - For static methods or platform channels:
     - Create a new file named mock_xxx.dart (where xxx is the package name)
     - Place in test/utils/ directory
     - Example implementation:
     ```dart
     const channel = MethodChannel('channel_name');
     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
         .setMockMethodCallHandler(channel, (call) async {
       // Mock implementation
     });
     ```
   - Create dedicated mock utilities for reusable mocks
   - Always clean up mocks in tearDown

3. Test Validation Process:
   - Run all tests before submitting changes
   - Fix any failing tests
   - Update tests when modifying existing functionality
   - Ensure test names clearly describe the testing scenario
   - Keep test code clean and maintainable

## Firebase Integration

1. Configuration:
   - Use FlutterFire CLI for setup
   - Maintain separate environments (dev/prod)
   - Configure crash reporting and analytics

2. Features:
   - Analytics for user behavior
   - Crashlytics for error reporting
   - Remote Config for feature flags

## Version Management

1. Flutter Version:
   - Using FVM (Flutter Version Management)
   - Version is specified in `.fvmrc`
   - Always use FVM commands for Flutter operations

## Documentation Guidelines

1. Documentation Comments:
   - Write comprehensive documentation comments in English
   - Use dartdoc Macros for reusability
   - Use dartdoc Macros especially for class documentation to maintain consistency
   - Examples of dartdoc Macros usage:
     ```dart
     // Template macro
     /// {@template foo}
     /// This is a reusable documentation comment.
     /// {@endtemplate}
     
     // Reference the template
     /// {@macro foo}
     ```
   - Keep documentation up to date with code changes
   - Include examples and use cases where applicable

## Quality Assurance

1. Compile Validation:
   - Ensure all code compiles without errors
   - Fix all compiler errors before marking work as complete
   - Address all static analysis warnings
   - Run build_runner and verify generated code

2. Code Review:
   - Self-review changes before submission
   - Ensure all tests pass
   - Verify documentation is complete and accurate
   - Check that code follows project style guidelines

## Internationalization Guidelines

1. Framework Usage:
   - Slang (https://pub.dev/packages/slang) is used for internationalization
   - Follow the Slang pattern for all translations
   - Use the code generation workflow for type-safe translations
   - All translations must be defined in appropriate i18n files

2. Translation Package Structure:
   - Translations are centralized in the `packages/core/i18n` package
   - Translation files are located in `lib/src/i18n/` directory
   - Currently supports English (`app_en.yaml`) and Japanese (`app_ja.yaml`)
   - New languages should be added as separate YAML files following the same naming convention
   - Generated code is stored in `lib/src/gen/` directory

3. Message Structure:
   - Provide clear and concise messages
   - Include action items when necessary
   - Maintain appropriate tone for each language (e.g., formal in Japanese, concise in English)

4. Localization Implementation:
   - All user-facing text must be internationalized
   - Account for cultural considerations in each language
   - Maintain consistent message structure across languages

5. i18n File Management:
   - Organize messages in appropriate hierarchical structure
   - Group related messages together
   - Consider reusability for common messages
   - Use descriptive keys that reflect the message context

6. Message Handling:
   - Provide appropriate context in messages
   - Include recovery steps when applicable
   - Prioritize user data protection
   - Format dates, numbers, and currencies according to locale
