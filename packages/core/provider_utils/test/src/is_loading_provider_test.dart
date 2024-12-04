import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider_utils/src/is_loading_provider.dart';

import '../util/provider_container.dart';

void main() {
  group('IsLoading', () {
    test('Initial state of isLoadingProvider should be false', () {
      final container = createContainer();
      expect(container.read(isLoadingProvider), false);
    });

    group('hide', () {
      test('Calling hide should set the state to false', () {
        final container = createContainer();
        container.read(isLoadingProvider.notifier).show();
        container.read(isLoadingProvider.notifier).hide();
        expect(container.read(isLoadingProvider), false);
      });

      test('Calling hide multiple times should keep the state false', () {
        final container = createContainer();
        container.read(isLoadingProvider.notifier).hide();
        container.read(isLoadingProvider.notifier).hide();

        expect(container.read(isLoadingProvider), false);
      });
    });

    group('show', () {
      test('Calling show should set the state to true', () {
        final container = createContainer();
        container.read(isLoadingProvider.notifier).show();
        expect(container.read(isLoadingProvider), true);
      });

      test('Calling show multiple times should keep the state true', () {
        final container = createContainer();
        container.read(isLoadingProvider.notifier).show();
        container.read(isLoadingProvider.notifier).show();
        expect(container.read(isLoadingProvider), true);
      });
    });
  });

  group('WidgetRefExtensionForLoading', () {
    testWidgets('WidgetRefExtensionForLoading', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestWidget(),
          ),
        ),
      );

      // Initial state should be false
      expect(find.text('Loading: false'), findsOneWidget);

      // Tap the show button and verify state changes to true
      await tester.tap(find.text('Show Loading'));
      await tester.pump();
      expect(find.text('Loading: true'), findsOneWidget);

      // Tap the hide button and verify state changes back to false
      await tester.tap(find.text('Hide Loading'));
      await tester.pump();
      expect(find.text('Loading: false'), findsOneWidget);
    });
  });
}

class TestWidget extends ConsumerWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Test Widget')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Loading: $isLoading'),
          ElevatedButton(
            onPressed: () => ref.showLoading(),
            child: const Text('Show Loading'),
          ),
          ElevatedButton(
            onPressed: () => ref.hideLoading(),
            child: const Text('Hide Loading'),
          ),
        ],
      ),
    );
  }
}
