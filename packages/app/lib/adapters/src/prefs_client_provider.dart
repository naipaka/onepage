import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'prefs_client_provider.g.dart';

/// Provider for the shared preferences client.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.
@Riverpod(keepAlive: true)
PrefsClient prefsClient(Ref ref) {
  throw UnimplementedError(
    'PrefsClient provider must be overridden with an initialized instance '
    'in main.dart',
  );
}

/// Provider for text input haptic feedback enabled state.
///
/// This provider manages the text input haptic feedback setting,
/// providing reactive updates when the preference changes.
@riverpod
class TextInputHapticEnabled extends _$TextInputHapticEnabled {
  @override
  bool build() {
    final prefsClient = ref.watch(prefsClientProvider);
    return prefsClient.textInputHapticEnabled;
  }

  /// Updates the text input haptic feedback enabled state.
  ///
  /// This method updates both the provider state and persists the change
  /// to SharedPreferences.
  Future<void> setEnabled({required bool enabled}) async {
    state = enabled;
    final prefsClient = ref.read(prefsClientProvider);
    await prefsClient.setTextInputHapticEnabled(enabled: enabled);
  }
}

/// Provider for other haptic feedback enabled state.
///
/// This provider manages the other haptic feedback setting (button taps,
/// toggles, navigation), providing reactive updates when the preference
/// changes.
@riverpod
class OtherHapticEnabled extends _$OtherHapticEnabled {
  @override
  bool build() {
    final prefsClient = ref.watch(prefsClientProvider);
    return prefsClient.otherHapticEnabled;
  }

  /// Updates the other haptic feedback enabled state.
  ///
  /// This method updates both the provider state and persists the change
  /// to SharedPreferences.
  Future<void> setEnabled({required bool enabled}) async {
    state = enabled;
    final prefsClient = ref.read(prefsClientProvider);
    await prefsClient.setOtherHapticEnabled(enabled: enabled);
  }
}
