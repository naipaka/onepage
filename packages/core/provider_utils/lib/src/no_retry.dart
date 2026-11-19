/// Retries no provider that fails.
///
/// Pass it as `retry` to every `ProviderScope` and `ProviderContainer`, so that
/// a failed provider shows its error at once.
Duration? noRetry(int retryCount, Object error) => null;
