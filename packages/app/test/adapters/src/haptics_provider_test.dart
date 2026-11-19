import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/haptics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onepage/adapters/adapters.dart';
import 'package:provider_utils/provider_utils.dart';

import '../../utils/mock.dart';

void main() {
  group('HapticsProvider', () {
    late ProviderContainer container;
    late MockPrefsClient mockPrefsClient;

    setUp(() {
      mockPrefsClient = MockPrefsClient();
      when(() => mockPrefsClient.textInputHapticEnabled).thenReturn(true);
      when(() => mockPrefsClient.otherHapticEnabled).thenReturn(true);

      container = ProviderContainer(
        retry: noRetry,
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
  });
}
