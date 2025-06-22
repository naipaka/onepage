import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:utils/src/hooks/src/undo_history_controller.dart';

import 'mock.dart';

void main() {
  testWidgets('debugFillProperties', (tester) async {
    await tester.pumpWidget(
      HookBuilder(
        builder: (context) {
          useUndoHistoryController();
          return const SizedBox();
        },
      ),
    );

    final element = tester.element(find.byType(HookBuilder));

    expect(
      element
          .toDiagnosticsNode(style: DiagnosticsTreeStyle.offstage)
          .toStringDeep(),
      equalsIgnoringHashCodes(
        'HookBuilder\n'
        ' │ useUndoHistoryController:\n'
        ' │   UndoHistoryController#00000(UndoHistoryValue(canUndo: false,\n'
        ' │   canRedo: false))\n'
        ' └SizedBox(renderObject: RenderConstrainedBox#00000)\n',
      ),
    );
  });

  group('useUndoHistoryController', () {
    testWidgets('initial values match the default constructor', (tester) async {
      late UndoHistoryController hookController;
      final directController = UndoHistoryController();

      await tester.pumpWidget(
        HookBuilder(
          builder: (context) {
            hookController = useUndoHistoryController();
            return Container();
          },
        ),
      );

      expect(hookController.value, directController.value);
      expect(hookController.value.canUndo, directController.value.canUndo);
      expect(hookController.value.canRedo, directController.value.canRedo);
    });

    testWidgets("returns a controller instance that doesn't change", (
      tester,
    ) async {
      late UndoHistoryController first;
      late UndoHistoryController second;

      await tester.pumpWidget(
        HookBuilder(
          builder: (context) {
            first = useUndoHistoryController();
            return Container();
          },
        ),
      );

      expect(first, isA<UndoHistoryController>());

      await tester.pumpWidget(
        HookBuilder(
          builder: (context) {
            second = useUndoHistoryController();
            return Container();
          },
        ),
      );

      expect(identical(first, second), isTrue);
    });

    testWidgets('passes hook parameters to the controller', (tester) async {
      const initialValue = UndoHistoryValue(
        canUndo: true,
        canRedo: true,
      );

      late UndoHistoryController controller;

      await tester.pumpWidget(
        HookBuilder(
          builder: (context) {
            controller = useUndoHistoryController(
              value: initialValue,
            );
            return Container();
          },
        ),
      );

      expect(controller.value, same(initialValue));
    });

    testWidgets('disposes the controller on unmount', (tester) async {
      late UndoHistoryController controller;

      await tester.pumpWidget(
        HookBuilder(
          builder: (context) {
            controller = useUndoHistoryController();
            return Container();
          },
        ),
      );

      await tester.pumpWidget(const SizedBox());

      expect(
        () => controller.addListener(() {}),
        throwsA(
          isFlutterError.having(
            (e) => e.message,
            'message',
            contains('disposed'),
          ),
        ),
      );
    });
  });
}
