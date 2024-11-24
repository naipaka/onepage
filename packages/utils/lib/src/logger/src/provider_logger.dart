import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extension/extension.dart';
import 'logger.dart';

/// Types of `Provider` events.
/// By specifying this event as a string in `dart_defines` with `providerLogPrint`,
/// the corresponding log will be output.
enum _ProviderEvent {
  add,
  update,
  dispose,
  error,
}

/// A class that logs events of `Provider`.
class ProviderLogger implements ProviderObserver {
  /// Creates an instance of [ProviderLogger].
  ProviderLogger() {
    const providerLogPrint = String.fromEnvironment('providerLogPrint');
    // If the string is empty, set an empty array and do not output logs.
    if (providerLogPrint.isEmpty) {
      outputLogTypes = [];
      return;
    }

    outputLogTypes = providerLogPrint
        .split(',')
        .map((e) => _ProviderEvent.values.byName(e))
        .toList();
  }

  /// The types of events to log.
  @visibleForTesting
  late final List<_ProviderEvent> outputLogTypes;

  void _print({
    required _ProviderEvent providerEvent,
    required ProviderBase<dynamic> provider,
    Object? value,
  }) {
    // If the event is not one of the specified events to log, do nothing.
    if (!outputLogTypes.contains(providerEvent)) {
      return;
    }

    final eventName = providerEvent.name.toUpperCase();
    final providerName = provider.name ?? provider.runtimeType;

    final result =
        (value == null) ? '' : '- ${value.toString().trimAtMaxLength(100)}';

    logger.finest('[$eventName] $providerName $result');
  }

  @override
  void didAddProvider(
    ProviderBase<dynamic> provider,
    Object? value,
    ProviderContainer _,
  ) {
    _print(
      providerEvent: _ProviderEvent.add,
      provider: provider,
      value: value,
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase<dynamic> provider,
    Object? _,
    Object? newValue,
    ProviderContainer __,
  ) {
    _print(
      providerEvent: _ProviderEvent.update,
      provider: provider,
      value: newValue,
    );
  }

  @override
  void didDisposeProvider(
    ProviderBase<dynamic> provider,
    ProviderContainer _,
  ) {
    _print(
      providerEvent: _ProviderEvent.dispose,
      provider: provider,
    );
  }

  @override
  void providerDidFail(
    ProviderBase<dynamic> provider,
    Object error,
    StackTrace _,
    ProviderContainer __,
  ) {
    _print(
      providerEvent: _ProviderEvent.error,
      provider: provider,
      value: error,
    );
  }
}
