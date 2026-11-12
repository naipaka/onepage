import 'package:diary/diary.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  group('DiaryTextField', () {
    late List<String> saved;

    setUp(() {
      saved = [];
    });

    Future<void> pumpField(WidgetTester tester, {String? content}) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DiaryTextField(content: content, save: saved.add),
          ),
        ),
      );
    }

    void moveToBackground(WidgetTester tester) {
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      addTearDown(
        () => tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        ),
      );
    }

    testWidgets('does not save an empty field without a diary', (tester) async {
      await pumpField(tester);

      moveToBackground(tester);

      expect(saved, isEmpty);
    });

    testWidgets('does not save unchanged content', (tester) async {
      await pumpField(tester, content: 'diary');

      moveToBackground(tester);

      expect(saved, isEmpty);
    });

    testWidgets('saves text typed into a field without a diary', (
      tester,
    ) async {
      await pumpField(tester);
      await tester.enterText(find.byType(TextField), 'new');

      moveToBackground(tester);
      await tester.pump(const Duration(seconds: 3));

      expect(saved, contains('new'));
    });

    testWidgets('saves the same text once before the diary updates', (
      tester,
    ) async {
      await pumpField(tester);
      await tester.enterText(find.byType(TextField), 'new');

      tester.binding
        ..handleAppLifecycleStateChanged(AppLifecycleState.inactive)
        ..handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      moveToBackground(tester);
      await tester.pump(const Duration(seconds: 3));

      expect(saved, ['new']);
    });

    testWidgets('saves again when the saved content comes back', (
      tester,
    ) async {
      await pumpField(tester);
      await tester.enterText(find.byType(TextField), 'new');
      moveToBackground(tester);
      await pumpField(tester, content: 'new');
      await tester.enterText(find.byType(TextField), 'newer');

      moveToBackground(tester);
      await tester.pump(const Duration(seconds: 3));

      expect(saved, ['new', 'newer']);
    });

    testWidgets('saves when tapping outside the field', (tester) async {
      await pumpField(tester);
      await tester.enterText(find.byType(TextField), 'new');

      await tester.tapAt(const Offset(400, 500));
      await tester.pump(const Duration(seconds: 3));

      expect(saved, contains('new'));
    });

    testWidgets('saves when existing content is cleared', (tester) async {
      await pumpField(tester, content: 'diary');
      await tester.enterText(find.byType(TextField), '');

      moveToBackground(tester);
      await tester.pump(const Duration(seconds: 3));

      expect(saved, contains(''));
    });
  });
}
