import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/haptics.dart';

import 'utils/mock.mocks.dart';

void main() {
  group('Haptics library exports', () {
    test('exports Haptics class', () {
      final mockPrefsClient = MockPrefsClient();
      final haptics = Haptics(prefsClient: mockPrefsClient);
      expect(haptics, isA<Haptics>());
    });
  });
}
