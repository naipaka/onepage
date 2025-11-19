import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:onepage/adapters/adapters.dart';

void main() {
  group('TrackerProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('trackerProvider throws UnimplementedError by default', () {
      expect(
        () => container.read(trackerProvider),
        throwsA(
          predicate(
            (e) =>
                e.toString().contains('UnimplementedError') ||
                (e is Error && e.toString().contains('UnimplementedError')),
          ),
        ),
      );
    });
  });
}
