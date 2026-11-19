---
paths:
  - "packages/**/test/**"
  - "packages/core/**"
  - "packages/features/**"
---

# Testing Guidelines

- **100% Test Coverage Required**: All packages except app/ and widgets/ must achieve 100% test coverage
  - Verify coverage with `fvm flutter test --coverage` in each package, or `fvm dart test --coverage-path=coverage/lcov.info` in a Dart package such as `tools/one_page_lints`
  - Check lcov.info: LF (Lines Found) = LH (Lines Hit)
  - Add comprehensive tests for all new functionality
  - **NEVER compromise on this requirement**: When user specifies 100% coverage, it must be achieved regardless of technical difficulty
  - **Platform-specific code coverage**: Use appropriate mocking strategies to cover all code paths, including platform-specific implementations
- Use real instances of the classes that run completely in a test, and check the outcome (database rows, files) instead of the calls
  - A package that needs help to create one in tests provides it in `lib/testing.dart`, like `createInMemoryDbClient` in `package:db_client/testing.dart`
  - `PhotoStorage` takes a temporary directory
- Mock only types the project owns. A class that wraps native code, Firebase, or a platform plugin (such as `Tracker`, `NotificationClient`, `PrefsClient`, and `Configurator`) is mocked as a whole in the tests of the code that uses it
  - Only the wrapping package's own tests mock or fake the third-party types, so no other package depends on them
- Write mocks by hand with mocktail: `class MockFoo extends Mock implements Foo;`
- In widget tests, real file IO never completes, so replace a class that reads or writes files with a hand-written `Fake` (`class _FakeFoo extends Fake implements Foo`)
- Put a package's mock classes in `test/utils/mock.dart`
- Platform channel mocks use `TestDefaultBinaryMessengerBinding`
- Always clean up mocks in `tearDown`
- **All tests must pass**: Failing tests are not acceptable for task completion

## Golden Tests

- Take golden images with `GoldenTestHelpers.expectGoldenMatches` in `packages/app/test/golden`. It draws text with Noto Sans JP from `test/golden/fonts` and icons with the Material icon font, in place of the iOS system font that tests do not have
- Take a golden image of each state of a page whose look the app defines, such as a dialog, a sheet, or a list with data. Check a state that shows only a loading indicator with a widget test
- Take each state in the three variants of `GoldenVariant`: light theme English, dark theme English, and light theme Japanese
- Put states that can appear together in one image, such as days with and without a photo on the home page
- Build a state with the arguments of `expectGoldenMatches`: data in `dbClient` and `photoStorage`, settings in `prefsClient`, and providers in `overrides`. Open a dialog or a sheet with taps in `act`
- For a state with an endless animation, such as a loading indicator, reach the state in `act` and pump a fixed time. Riverpod stops updating the widgets under a disabled `TickerMode`, so it cannot stop the animation
- Pass text in golden tests from the translations (`context.t`), so that the Japanese images show Japanese
- Build the text styles of a theme from its `TextTheme`. Tests draw a `TextStyle` with no font family in boxes
