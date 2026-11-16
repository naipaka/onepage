import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/haptics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';

import '../../utils/clients.dart';

void main() {
  group('HapticsProvider', () {
    test('hapticsProvider provides Haptics instance', () async {
      final container = ProviderContainer(
        overrides: [
          prefsClientProvider.overrideWithValue(await createPrefsClient()),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(hapticsProvider), isA<Haptics>());
    });
  });
}
