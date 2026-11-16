import 'package:flutter_test/flutter_test.dart';
import 'package:haptics/haptics.dart';
import 'package:prefs_client/prefs_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Haptics library exports', () {
    test('exports Haptics class', () async {
      SharedPreferences.setMockInitialValues({});
      final haptics = Haptics(prefsClient: await PrefsClient.initialize());
      expect(haptics, isA<Haptics>());
    });
  });
}
