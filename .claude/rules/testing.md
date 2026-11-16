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
- Use real instances of the app's own classes, and check the outcome (database rows, stored preferences, files) instead of the calls
  - `DbClient`: `DbClient.forTesting(NativeDatabase.memory())`
  - `PrefsClient`: `PrefsClient.initialize()` after `SharedPreferences.setMockInitialValues`
  - `PhotoStorage`: a temporary directory
- Mock only classes that call native code, Firebase, or platform plugins directly, with mocktail: write `class MockFoo extends Mock implements Foo;` by hand
- In widget tests, real file IO never completes, so replace a class that reads or writes files with a hand-written `Fake` (`class _FakeFoo extends Fake implements Foo`)
- Put a package's mock classes in `test/utils/mock.dart`
- Platform channel mocks use `TestDefaultBinaryMessengerBinding`
- Always clean up mocks in `tearDown`
- **All tests must pass**: Failing tests are not acceptable for task completion
