import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgets/widgets.dart';

void main() {
  const colorScheme = ColorScheme.light(
    surfaceContainerLowest: Color(0xFFFFFFFF),
    onSurface: Color(0xFF111111),
    error: Color(0xFFAA0000),
  );

  Future<BuildContext> pumpApp(
    WidgetTester tester, {
    ThemeData? theme,
  }) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? ThemeData(colorScheme: colorScheme),
        home: Scaffold(
          body: Builder(
            builder: (c) {
              context = c;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    return context;
  }

  Color? iconColor(WidgetTester tester, IconData icon) {
    return IconTheme.of(tester.element(find.byIcon(icon))).color;
  }

  BoxDecoration cardDecoration(WidgetTester tester) {
    final container = tester.widget<Container>(
      find.ancestor(
        of: find.byType(Row),
        matching: find.byType(Container),
      ),
    );
    return container.decoration! as BoxDecoration;
  }

  group('showSuccessToast', () {
    testWidgets('shows the title, description, and icon on the card', (
      tester,
    ) async {
      final context = await pumpApp(tester);

      showSuccessToast(
        context,
        title: 'Saved',
        description: 'All entries',
        icon: const Icon(Icons.backup_outlined),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('All entries'), findsOneWidget);
      expect(iconColor(tester, Icons.backup_outlined), colorScheme.onSurface);
      final decoration = cardDecoration(tester);
      expect(decoration.color, colorScheme.surfaceContainerLowest);
      expect(
        decoration.boxShadow!.single.color,
        colorScheme.shadow.withValues(alpha: 0.12),
      );
    });

    testWidgets('uses a stronger shadow in the dark theme', (tester) async {
      final context = await pumpApp(
        tester,
        theme: ThemeData(colorScheme: const ColorScheme.dark()),
      );

      showSuccessToast(
        context,
        title: 'Saved',
        icon: const Icon(Icons.backup_outlined),
      );
      await tester.pump();

      expect(
        cardDecoration(tester).boxShadow!.single.color,
        const ColorScheme.dark().shadow.withValues(alpha: 0.35),
      );
    });
  });

  group('showErrorToast', () {
    testWidgets('shows the title with an error icon', (tester) async {
      final context = await pumpApp(tester);

      showErrorToast(context, title: 'Failed');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Failed'), findsOneWidget);
      expect(iconColor(tester, Icons.error_outline), colorScheme.error);
    });
  });

  group('toast', () {
    testWidgets('closes three seconds after it appears', (tester) async {
      final context = await pumpApp(tester);

      showErrorToast(context, title: 'Failed');
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Failed'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      expect(find.text('Failed'), findsNothing);
    });

    testWidgets('replaces the toast on screen', (tester) async {
      final context = await pumpApp(tester);

      showErrorToast(context, title: 'First');
      await tester.pump();
      showErrorToast(context, title: 'Second');
      await tester.pump();

      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Second'), findsNothing);
    });

    testWidgets('closes when the user swipes it away', (tester) async {
      final context = await pumpApp(tester);

      showErrorToast(context, title: 'Failed');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.fling(find.text('Failed'), const Offset(500, 0), 1000);
      await tester.pumpAndSettle();

      expect(find.text('Failed'), findsNothing);
    });

    testWidgets('stays above the keyboard', (tester) async {
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      final context = await pumpApp(tester);

      showErrorToast(context, title: 'Failed');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final keyboardTop = screenHeight - 300 / tester.view.devicePixelRatio;
      expect(
        tester.getBottomLeft(find.byType(Row)).dy,
        lessThanOrEqualTo(keyboardTop),
      );
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });
  });
}
