import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lifecycle_provider.g.dart';

/// {@template appLifecycleProvider}
/// Provider for app lifecycle state.
/// {@endtemplate}
@riverpod
class AppLifecycle extends _$AppLifecycle with WidgetsBindingObserver {
  @override
  AppLifecycleState build() {
    final binding = WidgetsBinding.instance..addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));
    return AppLifecycleState.resumed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    this.state = state;
    super.didChangeAppLifecycleState(state);
  }
}

/// Extension on AppLifecycleState for convenience methods.
extension AppLifecycleStateExtension on AppLifecycleState {
  /// Whether the app is currently resumed.
  bool get isResumed => this == AppLifecycleState.resumed;
}
