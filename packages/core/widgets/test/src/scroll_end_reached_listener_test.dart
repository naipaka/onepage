import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:widgets/widgets.dart';

void main() {
  const itemExtent = 100.0;

  Widget list({required int itemCount}) {
    return ListView.builder(
      itemExtent: itemExtent,
      itemCount: itemCount,
      itemBuilder: (context, index) => Text('$index'),
    );
  }

  Future<List<void>> pumpListener(
    WidgetTester tester, {
    required Widget child,
  }) async {
    final calls = <void>[];
    await tester.pumpWidget(
      MaterialApp(
        home: ScrollEndReachedListener(
          onEndReached: () => calls.add(null),
          child: child,
        ),
      ),
    );
    await tester.pump();
    return calls;
  }

  ScrollPosition position(WidgetTester tester) {
    return tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position;
  }

  testWidgets('does not call while more than a viewport is left', (
    tester,
  ) async {
    final calls = await pumpListener(tester, child: list(itemCount: 100));

    position(tester).jumpTo(1000);
    await tester.pump();

    expect(
      position(tester).extentAfter,
      greaterThan(position(tester).viewportDimension),
    );
    expect(calls, isEmpty);
  });

  testWidgets('calls when less than a viewport is left', (tester) async {
    final calls = await pumpListener(tester, child: list(itemCount: 100));

    final scrollPosition = position(tester);
    scrollPosition.jumpTo(scrollPosition.maxScrollExtent - 500);
    await tester.pump();

    expect(
      scrollPosition.extentAfter,
      lessThan(scrollPosition.viewportDimension),
    );
    expect(calls, isNotEmpty);
  });

  testWidgets('calls on the first layout of short content', (tester) async {
    final calls = await pumpListener(tester, child: list(itemCount: 8));

    expect(calls, isNotEmpty);
  });

  testWidgets('calls when the content gets shorter without scrolling', (
    tester,
  ) async {
    final itemCount = ValueNotifier(100);
    addTearDown(itemCount.dispose);
    final calls = await pumpListener(
      tester,
      child: ValueListenableBuilder(
        valueListenable: itemCount,
        builder: (context, count, _) => list(itemCount: count),
      ),
    );
    expect(calls, isEmpty);

    itemCount.value = 8;
    await tester.pump();
    await tester.pump();

    expect(calls, isNotEmpty);
  });

  testWidgets('ignores a scrollable nested inside', (tester) async {
    final calls = await pumpListener(
      tester,
      child: ListView(
        itemExtent: itemExtent,
        children: [
          const SizedBox(
            height: itemExtent,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text('nested'),
            ),
          ),
          for (var i = 0; i < 100; i++) Text('$i'),
        ],
      ),
    );

    expect(calls, isEmpty);
  });

  testWidgets('calls nothing without a callback', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScrollEndReachedListener(
          onEndReached: null,
          child: list(itemCount: 8),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
