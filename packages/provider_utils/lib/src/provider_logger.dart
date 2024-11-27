import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return names.split(',').map((e) => values.byName(e)).toList();
  }
}

/// A class that logs events of `Provider`.
class ProviderLogger implements ProviderObserver {
  /// Creates an instance of [ProviderLogger].
  const ProviderLogger({
    required this.outputLogTypes,
    required this.logger,
  });

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
      providerEvent: ProviderEvent.add,
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
      providerEvent: ProviderEvent.update,
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
      providerEvent: ProviderEvent.dispose,
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
      providerEvent: ProviderEvent.error,
      provider: provider,
      value: error,
    );
  }
}
