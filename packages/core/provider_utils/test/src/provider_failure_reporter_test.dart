import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_utils/provider_utils.dart';

import '../util/provider_container.dart';

void main() {
  group('ProviderFailureReporter', () {
    late List<Object> failures;
    late ProviderContainer container;

    setUp(() {
      failures = [];
      container = createContainer(
        observers: [
          ProviderFailureReporter(
            onFailure: (error, stackTrace) => failures.add(error),
          ),
        ],
      );
    });

    test(
      'passes an error once when a provider awaits the failed one',
      () async {
        final error = Exception('failed');
        final failing = FutureProvider<int>((ref) async => throw error);
        final reading = FutureProvider<int>((ref) => ref.watch(failing.future));
        container.listen(reading, (_, _) {});

        await expectLater(container.read(reading.future), throwsA(error));

        expect(failures, [error]);
      },
    );

    test('passes an error once when a provider reads the failed one', () {
      final error = StateError('failed');
      final failing = Provider<int>((ref) => throw error);
      final reading = Provider<int>((ref) => ref.watch(failing) + 1);

      expect(() => container.read(reading), throwsA(anything));

      expect(failures, [error]);
    });

    test('passes each failure of an error that is a string', () async {
      final failing = FutureProvider<int>(
        (ref) => Future.error('failed', StackTrace.current),
      );
      container.listen(failing, (_, _) {});

      await expectLater(container.read(failing.future), throwsA('failed'));
      container.invalidate(failing);
      await expectLater(container.read(failing.future), throwsA('failed'));

      expect(failures, ['failed', 'failed']);
    });
  });
}
