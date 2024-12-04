import 'dart:async';

/// A class for executing functions with a delay.
///
/// Executes the callback function after the delay specified in [delay].
/// If called multiple times quickly, only the last call will be executed.
class Debounce {
  /// Creates a [Debounce] instance.
  Debounce({
    required this.delay,
  });

  /// The delay duration.
  final Duration delay;

  /// The timer used internally.
  Timer? _timer;

  /// Executes the callback function with a delay.
  void call(void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  /// Disposes of the instance.
  void dispose() {
    _timer?.cancel();
  }
}
