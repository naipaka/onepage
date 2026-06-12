---
paths:
  - "packages/**/test/**"
  - "packages/core/**"
  - "packages/features/**"
---

# Testing Guidelines

- **100% Test Coverage Required**: All packages except app/ and widgets/ must achieve 100% test coverage
  - Verify coverage with `fvm flutter test --coverage` in each package
  - Check lcov.info: LF (Lines Found) = LH (Lines Hit)
  - Add comprehensive tests for all new functionality
  - **NEVER compromise on this requirement**: When user specifies 100% coverage, it must be achieved regardless of technical difficulty
  - **Platform-specific code coverage**: Use appropriate mocking strategies to cover all code paths, including platform-specific implementations
- Use Mockito for mocking (`@GenerateMocks` annotation)
- Mock files in `test/utils/mock_*.dart`
- Platform channel mocks use `TestDefaultBinaryMessengerBinding`
- Always clean up mocks in `tearDown`
- **All tests must pass**: Failing tests are not acceptable for task completion
