import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/haptics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:prefs_client/prefs_client.dart';

import 'haptics_provider_test.mocks.dart';

@GenerateMocks([PrefsClient])
void main() {
  group('HapticsProvider', () {
    late ProviderContainer container;
    late MockPrefsClient mockPrefsClient;

    setUp(() {
      mockPrefsClient = MockPrefsClient();
      when(mockPrefsClient.textInputHapticEnabled).thenReturn(true);
      when(mockPrefsClient.otherHapticEnabled).thenReturn(true);

      container = ProviderContainer(
        overrides: [
          prefsClientProvider.overrideWithValue(mockPrefsClient),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('hapticsProvider provides Haptics instance', () {
      final haptics = container.read(hapticsProvider);
      expect(haptics, isA<Haptics>());
    });

    test('hapticsProvider uses PrefsClient dependency', () {
      final haptics = container.read(hapticsProvider);
      expect(haptics, isA<Haptics>());
    });
  });
}
