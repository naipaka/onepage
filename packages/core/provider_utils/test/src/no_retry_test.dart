import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../util/provider_container.dart';

void main() {
  group('noRetry', () {
    test('shows the error of a failed provider at once', () async {
      var builds = 0;
      final provider = FutureProvider<void>((ref) async {
        builds++;
        throw Exception('failed');
      });
      final container = createContainer()..listen(provider, (_, _) {});

      await expectLater(container.read(provider.future), throwsException);
      await Future<void>.delayed(const Duration(seconds: 1));

      expect(container.read(provider), isA<AsyncError<void>>());
      expect(builds, 1);
    });
  });
}
