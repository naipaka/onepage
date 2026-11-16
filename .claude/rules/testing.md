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
