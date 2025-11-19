import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:simple_logger/simple_logger.dart';
import 'package:utils/utils.dart';

/// Types of `Provider` events.
/// By specifying this event as a string in `dart_defines`
/// with `providerLogPrint`, the corresponding log will be output.
enum ProviderEvent {
  /// Logs when a provider is added.
  add,

  /// Logs when a provider is updated.
  update,

  /// Logs when a provider is disposed.
  dispose,

  /// Logs when a provider throws an error.
  error,

  /// Logs when a mutation starts.
  mutationStart,

  /// Logs when a mutation succeeds.
  mutationSuccess,

  /// Logs when a mutation fails.
  mutationError,

  /// Logs when a mutation is reset.
  mutationReset
  ;

  /// Returns a list of [ProviderEvent] from a comma-separated string of
  /// event names.
  ///
  /// The [names] parameter should be a comma-separated string where each
  /// event name corresponds to a value in the [ProviderEvent] enum.
  ///
  /// Example:
  /// ```dart
  /// final events = ProviderEvent.getEventsFromNames('add,update,error');
  /// // events will be [ProviderEvent.add, ProviderEvent.update, ProviderEvent.error]
  /// ```
  static List<ProviderEvent> getEventsFromNames(String names) {
    if (names.isEmpty) {
      return [];
    }
    return names.split(',').map((e) => values.byName(e)).toList();
  }
}

/// {@template provider_utils.ProviderLogger}
/// A class that logs events of `Provider`.
/// {@endtemplate}
base class ProviderLogger extends ProviderObserver {
  /// {@macro provider_utils.ProviderLogger}
  const ProviderLogger({required this.outputLogTypes, required this.logger});

  /// The types of events to log.
  final List<ProviderEvent> outputLogTypes;

  /// The logger instance to use.
  final SimpleLogger logger;

  void _print({
    required ProviderEvent providerEvent,
    required ProviderBase<dynamic> provider,
    Object? value,
  }) {
    // If the event is not one of the specified events to log, do nothing.
    if (!outputLogTypes.contains(providerEvent)) {
      return;
    }

    final eventName = providerEvent.name.toUpperCase();
    final providerName = provider.name ?? provider.runtimeType;

    final result = (value == null)
        ? ''
        : '- ${value.toString().trimAtMaxLength(100)}';

    logger.finest('[$eventName] $providerName $result');
  }

  @override
  void didAddProvider(
    ProviderObserverContext context,
    Object? value,
  ) {
    _print(
      providerEvent: ProviderEvent.add,
      provider: context.provider,
      value: value,
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    _print(
      providerEvent: ProviderEvent.update,
      provider: context.provider,
      value: newValue,
    );
  }

  @override
  void didDisposeProvider(
    ProviderObserverContext context,
  ) {
    _print(
      providerEvent: ProviderEvent.dispose,
      provider: context.provider,
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _print(
      providerEvent: ProviderEvent.error,
      provider: context.provider,
      value: error,
    );
  }

  @override
  void mutationStart(ProviderObserverContext context, Object? mutation) {
    _print(
      providerEvent: ProviderEvent.mutationStart,
      provider: context.provider,
      value: mutation,
    );
  }

  @override
  void mutationSuccess(
    ProviderObserverContext context,
    Object? mutation,
    Object? result,
  ) {
    _print(
      providerEvent: ProviderEvent.mutationSuccess,
      provider: context.provider,
      value: result,
    );
  }

  @override
  void mutationError(
    ProviderObserverContext context,
    Object? mutation,
    Object error,
    StackTrace stackTrace,
  ) {
    _print(
      providerEvent: ProviderEvent.mutationError,
      provider: context.provider,
      value: error,
    );
  }

  @override
  void mutationReset(ProviderObserverContext context, Object? mutation) {
    _print(
      providerEvent: ProviderEvent.mutationReset,
      provider: context.provider,
      value: mutation,
    );
  }
}
