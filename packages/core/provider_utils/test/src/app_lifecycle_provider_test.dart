import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_utils/src/app_lifecycle_provider.dart';

import '../util/provider_container.dart';

void main() {
  group('AppLifecycle', () {
    late ProviderContainer container;

    setUp(() {
      container = createContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should initialize with resumed state', (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const SizedBox(),
        ),
      );

      expect(container.read(appLifecycleProvider), AppLifecycleState.resumed);
    });

    testWidgets(
      'should update state when app lifecycle changes',
      (tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const SizedBox(),
          ),
        );

        final provider = container.read(appLifecycleProvider.notifier)
          ..didChangeAppLifecycleState(AppLifecycleState.paused);
        expect(container.read(appLifecycleProvider), AppLifecycleState.paused);

        provider.didChangeAppLifecycleState(AppLifecycleState.detached);
        expect(
          container.read(appLifecycleProvider),
          AppLifecycleState.detached,
        );

        provider.didChangeAppLifecycleState(AppLifecycleState.inactive);
        expect(
          container.read(appLifecycleProvider),
          AppLifecycleState.inactive,
        );

        provider.didChangeAppLifecycleState(AppLifecycleState.hidden);
        expect(container.read(appLifecycleProvider), AppLifecycleState.hidden);

        provider.didChangeAppLifecycleState(AppLifecycleState.resumed);
        expect(container.read(appLifecycleProvider), AppLifecycleState.resumed);
      },
    );

    testWidgets('should properly initialize and dispose', (tester) async {
      final widget = UncontrolledProviderScope(
        container: container,
        child: const SizedBox(),
      );

      await tester.pumpWidget(widget);

      final provider = container.read(appLifecycleProvider.notifier);
      expect(provider, isA<AppLifecycle>());

      expect(() => container.dispose(), returnsNormally);
    });

    test('should handle dispose properly when no widget is mounted', () {
      container.read(appLifecycleProvider.notifier);
      expect(() => container.dispose(), returnsNormally);
    });
  });

  group('AppLifecycleStateExtension', () {
    test('isResumed should return true only for resumed state', () {
      expect(AppLifecycleState.resumed.isResumed, isTrue);
      expect(AppLifecycleState.paused.isResumed, isFalse);
      expect(AppLifecycleState.detached.isResumed, isFalse);
      expect(AppLifecycleState.inactive.isResumed, isFalse);
      expect(AppLifecycleState.hidden.isResumed, isFalse);
    });
  });
}
