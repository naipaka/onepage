import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// {@template provider_utils.ProviderFailureReporter}
/// Passes the errors that providers fail with to [onFailure].
///
/// A provider that reads a failed provider fails with the same error, or with
/// a [ProviderException] around it. Each error object is passed once, except
/// strings, numbers, booleans, and records, which cannot be told apart.
/// {@endtemplate}
base class ProviderFailureReporter extends ProviderObserver {
  /// {@macro provider_utils.ProviderFailureReporter}
  new({required this.onFailure});

  /// Called with each error that a provider fails with.
  final void Function(Object error, StackTrace stackTrace) onFailure;

  final _passed = Expando<bool>();

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (error is ProviderException || _wasPassed(error)) {
      return;
    }
    onFailure(error, stackTrace);
  }

  bool _wasPassed(Object error) {
    if (error is String || error is num || error is bool || error is Record) {
      return false;
    }
    final passed = _passed[error] ?? false;
    _passed[error] = true;
    return passed;
  }
}
