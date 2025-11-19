import 'package:haptics/haptics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'prefs_client_provider.dart';

part 'haptics_provider.g.dart';

/// Provider for the haptics service.
///
/// This provider creates a Haptics instance with the PrefsClient dependency
/// injected for preference-based haptic feedback control.
@riverpod
Haptics haptics(Ref ref) {
  final prefsClient = ref.watch(prefsClientProvider);
  return Haptics(prefsClient: prefsClient);
}
