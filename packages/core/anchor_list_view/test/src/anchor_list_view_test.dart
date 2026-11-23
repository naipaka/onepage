import 'package:anchor_list_view/anchor_list_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

double heightOf(int v) => 40 + (v * 37 % 120).toDouble();
const height = 600.0;

/// Items are int values; the widget of each item is keyed by its value, and
/// findItemIndexCallback looks the value up, as a caller of ListView does.
Widget harness({
  required List<int> items,
  required int initialValue,
  double alignment = 0,
  AnchorListController? controller,
  ValueChanged<List<AnchorItemPosition>>? onPositions,
  ScrollPhysics? physics,
  bool findIndex = true,
  bool separators = false,
  EdgeInsets padding = EdgeInsets.zero,
  Widget Function(int value)? item,
}) {
  final indexes = {for (var i = 0; i < items.length; i++) items[i]: i};
  int? find(Key key) => key is ValueKey<int> ? indexes[key.value] : null;
  Widget build(BuildContext _, int i) =>
      item?.call(items[i]) ??
      SizedBox(
        key: ValueKey(items[i]),
        height: heightOf(items[i]),
        child: Text('item ${items[i]}'),
      );
  return MaterialApp(
    home: Scaffold(
      body: separators
          ? AnchorListView.separated(
              itemCount: items.length,
              initialIndex: indexes[initialValue] ?? 0,
              initialAlignment: alignment,
              controller: controller,
              onPositionsChanged: onPositions,
              physics: physics,
              padding: padding,
              findItemIndexCallback: findIndex ? find : null,
              separatorBuilder: (_, i) => SizedBox(
                height: 10,
                child: Text('sep ${items[i]}-${items[i + 1]}'),
              ),
              itemBuilder: build,
            )
          : AnchorListView.builder(
              itemCount: items.length,
              initialIndex: indexes[initialValue] ?? 0,
              initialAlignment: alignment,
              controller: controller,
              onPositionsChanged: onPositions,
              physics: physics,
              padding: padding,
              findChildIndexCallback: findIndex ? find : null,
              itemBuilder: build,
            ),
    ),
  );
}

Rect rectOf(WidgetTester tester, String text) =>
    tester.getRect(find.text(text, skipOffstage: false));
Rect itemRect(WidgetTester tester, int v) => rectOf(tester, 'item $v');

bool built(int v) =>
    find.text('item $v', skipOffstage: false).evaluate().isNotEmpty;

List<int> range(int from, int to) => [for (var i = from; i < to; i++) i];

Future<void> dragMany(WidgetTester tester, double dy) async {
  for (var i = 0; i < 10; i++) {
    await tester.drag(find.byType(AnchorListView), Offset(0, dy));
    await tester.pumpAndSettle();
  }
}

void main() {
  group('edges', () {
    for (final physics in <ScrollPhysics>[
      const ClampingScrollPhysics(),
      const BouncingScrollPhysics(),
    ]) {
      final name = physics.runtimeType;
      testWidgets('[$name] initial near the end stops at the end', (
        tester,
      ) async {
        await tester.pumpWidget(
          harness(
            items: range(0, 100),
            initialValue: 98,
            alignment: 0.5,
            physics: physics,
          ),
        );
        expect(itemRect(tester, 99).bottom, height);
      });

      testWidgets('[$name] initial near the start stops at the start', (
        tester,
      ) async {
        await tester.pumpWidget(
          harness(
            items: range(0, 100),
            initialValue: 1,
            alignment: 0.5,
            physics: physics,
          ),
        );
        expect(itemRect(tester, 0).top, 0);
      });

      testWidgets('[$name] jump near the end stops at the end in one frame', (
        tester,
      ) async {
        final controller = AnchorListController();
        await tester.pumpWidget(
          harness(
            items: range(0, 100),
            initialValue: 50,
            controller: controller,
            physics: physics,
          ),
        );
        controller.jumpToItem(99, alignment: 0.5);
        await tester.pump();
        expect(itemRect(tester, 99).bottom, height);
        await tester.pumpAndSettle();
        expect(itemRect(tester, 99).bottom, height);
      });

      testWidgets('[$name] dragging past the end shows no blank', (
        tester,
      ) async {
        await tester.pumpWidget(
          harness(
            items: range(0, 100),
            initialValue: 98,
            alignment: 0.5,
            physics: physics,
          ),
        );
        await dragMany(tester, -2000);
        expect(itemRect(tester, 99).bottom, height);
      });

      testWidgets('[$name] short list starts at the top', (tester) async {
        await tester.pumpWidget(
          harness(
            items: range(0, 3),
            initialValue: 2,
            alignment: 0.5,
            physics: physics,
          ),
        );
        expect(itemRect(tester, 0).top, 0);
      });

      for (final (initial, target) in [(10, 99), (90, 0), (95, 99), (4, 0)]) {
        testWidgets('[$name] animating $initial -> $target shows no blank', (
          tester,
        ) async {
          final controller = AnchorListController();
          await tester.pumpWidget(
            harness(
              items: range(0, 100),
              initialValue: initial,
              alignment: 0.5,
              controller: controller,
              physics: physics,
            ),
          );
          final future = controller.animateToItem(
            target,
            alignment: 0.5,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          var maxBlank = 0.0;
          for (var i = 0; i < 40; i++) {
            await tester.pump(const Duration(milliseconds: 16));
            if (built(0)) {
              maxBlank = [
                maxBlank,
                itemRect(tester, 0).top,
              ].reduce((a, b) => a > b ? a : b);
            }
            if (built(99)) {
              maxBlank = [
                maxBlank,
                height - itemRect(tester, 99).bottom,
              ].reduce((a, b) => a > b ? a : b);
            }
          }
          await tester.pumpAndSettle();
          await future;
          expect(maxBlank, lessThan(0.5));
        });
      }
    }
  });

  group('changing the items with findItemIndexCallback', () {
    testWidgets('prepend and append at once keep the position', (tester) async {
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 50, alignment: 0.5),
      );
      final before = itemRect(tester, 50).top;
      await tester.pumpWidget(
        harness(items: range(-30, 130), initialValue: 50, alignment: 0.5),
      );
      expect(itemRect(tester, 50).top, before);
      expect(tester.takeException(), isNull);
    });

    testWidgets('prepend after scrolling keeps the position', (tester) async {
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 50, alignment: 0.5),
      );
      await tester.drag(find.byType(AnchorListView), const Offset(0, 1500));
      await tester.pumpAndSettle();
      final probe = range(0, 100).where(built).firstWhere((v) {
        final r = itemRect(tester, v);
        return r.top >= 0 && r.bottom <= height;
      });
      final before = itemRect(tester, probe).top;
      await tester.pumpWidget(
        harness(items: range(-30, 100), initialValue: 50, alignment: 0.5),
      );
      expect(itemRect(tester, probe).top, before);
      await dragMany(tester, 2000);
      expect(itemRect(tester, -30).top, 0);
    });

    testWidgets('prepend 30 repeatedly, as the comparison app does', (
      tester,
    ) async {
      var items = range(0, 200);
      await tester.pumpWidget(
        harness(items: items, initialValue: 197, alignment: 0.5),
      );
      await tester.drag(find.byType(AnchorListView), const Offset(0, 400));
      await tester.pumpAndSettle();
      for (var n = 1; n <= 3; n++) {
        final probe = items.where(built).firstWhere((v) {
          final r = itemRect(tester, v);
          return r.top >= 0 && r.bottom <= height;
        });
        final before = itemRect(tester, probe).top;
        items = [...range(-30 * n, -30 * (n - 1)), ...items];
        await tester.pumpWidget(
          harness(items: items, initialValue: 197, alignment: 0.5),
        );
        expect(itemRect(tester, probe).top, before, reason: 'prepend #$n');
      }
    });

    testWidgets('append to a list whose end is visible', (tester) async {
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 99, alignment: 0.5),
      );
      final before = itemRect(tester, 95).top;
      await tester.pumpWidget(
        harness(items: range(0, 120), initialValue: 99, alignment: 0.5),
      );
      expect(itemRect(tester, 95).top, before);
      await dragMany(tester, -2000);
      expect(itemRect(tester, 119).bottom, height);
    });

    testWidgets('prepend keeps the state of the items', (tester) async {
      Widget counter(int v) => _Counter(key: ValueKey(v), label: 'item $v');
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 50, item: counter),
      );
      await tester.tap(find.text('item 51: 0'));
      await tester.pump();
      await tester.pumpWidget(
        harness(items: range(-30, 100), initialValue: 50, item: counter),
      );
      expect(find.text('item 51: 1'), findsOneWidget);
    });

    testWidgets('removing the center item does not throw', (tester) async {
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 50, alignment: 0.5),
      );
      await tester.pumpWidget(
        harness(
          items: [...range(0, 50), ...range(51, 100)],
          initialValue: 49,
          alignment: 0.5,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(built(51), isTrue);
    });

    testWidgets('shrinking below the center index does not throw', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 90, alignment: 0.5),
      );
      await tester.pumpWidget(
        harness(items: range(200, 210), initialValue: 200, alignment: 0.5),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(built(209), isTrue);
    });
  });

  group('changing the items without findItemIndexCallback', () {
    testWidgets('prepend keeps the index, as ListView does', (tester) async {
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          alignment: 0.5,
          findIndex: false,
        ),
      );
      final before = itemRect(tester, 50).top;
      await tester.pumpWidget(
        harness(
          items: range(-30, 100),
          initialValue: 50,
          alignment: 0.5,
          findIndex: false,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      // Index 50 is now item 20.
      expect(itemRect(tester, 20).top, before);
    });
  });

  group('visible items', () {
    testWidgets('reported after the first frame', (tester) async {
      final reports = <List<AnchorItemPosition>>[];
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          alignment: 0.5,
          onPositions: reports.add,
        ),
      );
      expect(reports, hasLength(1));
      final p = reports.single.firstWhere((p) => p.index == 50);
      expect(p.leadingEdge, 0.5);
    });

    testWidgets('reported with the new indexes after a prepend', (
      tester,
    ) async {
      final reports = <List<AnchorItemPosition>>[];
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          alignment: 0.5,
          onPositions: reports.add,
        ),
      );
      await tester.pumpWidget(
        harness(
          items: range(-30, 100),
          initialValue: 50,
          alignment: 0.5,
          onPositions: reports.add,
        ),
      );
      final p = reports.last.firstWhere((p) => p.index == 80);
      expect(p.leadingEdge, 0.5);
    });

    testWidgets('reported while scrolling', (tester) async {
      final reports = <List<AnchorItemPosition>>[];
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          onPositions: reports.add,
        ),
      );
      reports.clear();
      await tester.drag(find.byType(AnchorListView), const Offset(0, -300));
      await tester.pump();
      expect(reports.last.first.index, greaterThan(50));
    });
  });

  group('jumps', () {
    testWidgets('a near jump keeps the state of the items', (tester) async {
      final controller = AnchorListController();
      Widget counter(int v) => _Counter(key: ValueKey(v), label: 'item $v');
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          alignment: 0.5,
          controller: controller,
          item: counter,
        ),
      );
      await tester.tap(find.text('item 50: 0'));
      await tester.pump();
      controller.jumpToItem(52, alignment: 0.5);
      await tester.pump();
      expect(find.text('item 50: 1', skipOffstage: false), findsOneWidget);
      expect(tester.getRect(find.text('item 52: 0')).top, height * 0.5);
    });

    testWidgets('a far jump after a prepend uses the new indexes', (
      tester,
    ) async {
      final controller = AnchorListController();
      await tester.pumpWidget(
        harness(
          items: range(0, 1000),
          initialValue: 50,
          controller: controller,
        ),
      );
      await tester.pumpWidget(
        harness(
          items: range(-50, 1000),
          initialValue: 50,
          controller: controller,
        ),
      );
      controller.jumpToItem(950, alignment: 0.5);
      await tester.pump();
      expect(itemRect(tester, 900).top, height * 0.5);
      controller.jumpToItem(30, alignment: 0.5);
      await tester.pump();
      expect(itemRect(tester, -20).top, height * 0.5);
    });

    testWidgets('jump while a fling is running', (tester) async {
      final controller = AnchorListController();
      await tester.pumpWidget(
        harness(
          items: range(0, 1000),
          initialValue: 500,
          alignment: 0.5,
          controller: controller,
        ),
      );
      await tester.fling(
        find.byType(AnchorListView),
        const Offset(0, 500),
        3000,
      );
      await tester.pump(const Duration(milliseconds: 50));
      controller.jumpToItem(100, alignment: 0.5);
      await tester.pumpAndSettle();
      expect(itemRect(tester, 100).top, height * 0.5);
    });

    testWidgets('animate to a far item', (tester) async {
      final controller = AnchorListController();
      await tester.pumpWidget(
        harness(
          items: range(0, 1000),
          initialValue: 10,
          controller: controller,
        ),
      );
      final future = controller.animateToItem(
        900,
        alignment: 0.5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      await tester.pumpAndSettle();
      await future;
      expect(itemRect(tester, 900).top, height * 0.5);
    });

    for (final target in [100, 120, 60, 150]) {
      testWidgets('animate 197 -> $target does not throw', (tester) async {
        final controller = AnchorListController();
        await tester.pumpWidget(
          harness(
            items: range(0, 200),
            initialValue: 197,
            alignment: 0.5,
            controller: controller,
            separators: true,
          ),
        );
        final future = controller.animateToItem(
          target,
          alignment: 0.5,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        await tester.pumpAndSettle();
        await future;
        expect(tester.takeException(), isNull);
        expect(itemRect(tester, target).top, height * 0.5);
      });
    }
  });

  group('separators and padding', () {
    testWidgets('items and separators alternate around the center', (
      tester,
    ) async {
      await tester.pumpWidget(
        harness(items: range(0, 8), initialValue: 4, separators: true),
      );
      final order = <String>[
        for (var i = 0; i < 8; i++) ...[
          if (i > 0) 'sep ${i - 1}-$i',
          'item $i',
        ],
      ];
      for (var k = 1; k < order.length; k++) {
        expect(
          rectOf(tester, order[k]).top,
          rectOf(tester, order[k - 1]).bottom,
          reason: '${order[k - 1]} -> ${order[k]}',
        );
      }
    });

    testWidgets('prepend keeps the separators in place', (tester) async {
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          alignment: 0.5,
          separators: true,
        ),
      );
      final before = itemRect(tester, 50).top;
      await tester.pumpWidget(
        harness(
          items: range(-20, 120),
          initialValue: 50,
          alignment: 0.5,
          separators: true,
        ),
      );
      expect(itemRect(tester, 50).top, before);
      expect(rectOf(tester, 'sep 49-50').bottom, before);
      expect(rectOf(tester, 'sep 50-51').top, itemRect(tester, 50).bottom);
    });

    testWidgets('padding at both ends', (tester) async {
      const padding = EdgeInsets.fromLTRB(16, 40, 8, 80);
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 50, padding: padding),
      );
      await dragMany(tester, 3000);
      expect(itemRect(tester, 0).top, 40);
      expect(itemRect(tester, 0).left, 16);
      await dragMany(tester, -3000);
      expect(itemRect(tester, 99).bottom, height - 80);
    });
  });

  group('fade', () {
    Future<double> minOpacity(
      WidgetTester tester,
      Future<void> Function() animate,
    ) async {
      final fade = find.descendant(
        of: find.byType(AnchorListView),
        matching: find.byType(FadeTransition),
      );
      var min = 1.0;
      final future = animate();
      for (var i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        final o = tester.widget<FadeTransition>(fade.first).opacity.value;
        if (o < min) {
          min = o;
        }
      }
      await tester.pumpAndSettle();
      await future;
      return min;
    }

    Future<void> to(AnchorListController c, int index) => c.animateToItem(
      index,
      alignment: 0.5,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );

    Future<AnchorListController> setUp(WidgetTester tester) async {
      final c = AnchorListController();
      await tester.pumpWidget(
        harness(
          items: range(0, 200),
          initialValue: 197,
          alignment: 0.5,
          controller: c,
        ),
      );
      return c;
    }

    testWidgets('far: 197 -> 5 -> 198 -> 5 fades every time', (tester) async {
      final c = await setUp(tester);
      expect(await minOpacity(tester, () => to(c, 5)), 0);
      expect(await minOpacity(tester, () => to(c, 198)), 0);
      expect(await minOpacity(tester, () => to(c, 5)), 0);
      expect(itemRect(tester, 5).top, height * 0.5);
    });

    testWidgets('far: the center item after dragging away fades', (
      tester,
    ) async {
      final c = await setUp(tester);
      await minOpacity(tester, () => to(c, 5));
      await dragMany(tester, -3000);
      expect(await minOpacity(tester, () => to(c, 5)), 0);
      expect(itemRect(tester, 5).top, height * 0.5);
    });

    testWidgets('far: a neighbor of the center after dragging away fades', (
      tester,
    ) async {
      final c = await setUp(tester);
      await dragMany(tester, 3000);
      expect(await minOpacity(tester, () => to(c, 198)), 0);
      expect(await minOpacity(tester, () => to(c, 0)), 0);
      await dragMany(tester, 3000);
      expect(await minOpacity(tester, () => to(c, 197)), 0);
      // 197 cannot reach the middle: the items after it are shorter than
      // half of the viewport, so the list stops at the end.
      expect(itemRect(tester, 199).bottom, height);
    });

    testWidgets('far: after a prepend and dragging to the new start', (
      tester,
    ) async {
      final c = AnchorListController();
      await tester.pumpWidget(
        harness(items: range(0, 200), initialValue: 197, controller: c),
      );
      final items = range(-60, 200);
      await tester.pumpWidget(
        harness(items: items, initialValue: 197, controller: c),
      );
      await dragMany(tester, 3000);
      expect(itemRect(tester, -60).top, 0);
      expect(await minOpacity(tester, () => to(c, items.indexOf(198))), 0);
      expect(itemRect(tester, 199).bottom, height);
    });

    testWidgets('near: a visible item scrolls without fading', (tester) async {
      final c = await setUp(tester);
      final visible = range(0, 200).where((v) {
        if (!built(v)) {
          return false;
        }
        final r = itemRect(tester, v);
        return r.top >= 0 && r.bottom <= height;
      }).first;
      expect(await minOpacity(tester, () => to(c, visible)), 1);
      expect(itemRect(tester, visible).top, height * 0.5);
    });

    testWidgets('near: an item just outside the viewport scrolls without '
        'fading', (tester) async {
      final c = AnchorListController();
      await tester.pumpWidget(
        harness(items: range(0, 200), initialValue: 100, controller: c),
      );
      final below = range(
        100,
        200,
      ).firstWhere((v) => built(v) && itemRect(tester, v).top >= height);
      expect(await minOpacity(tester, () => to(c, below)), 1);
      expect(itemRect(tester, below).top, height * 0.5);
    });
  });

  group('controller as a ScrollController', () {
    testWidgets('offset is 0 when the center item is at the alignment', (
      tester,
    ) async {
      final c = AnchorListController();
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          alignment: 0.5,
          controller: c,
        ),
      );
      expect(c.offset, 0);
      expect(c.position.minScrollExtent, lessThan(0));
      expect(c.position.maxScrollExtent, greaterThan(0));
    });

    testWidgets('jumpTo and addListener work as in ScrollController', (
      tester,
    ) async {
      final c = AnchorListController();
      var calls = 0;
      c.addListener(() => calls++);
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 50, controller: c),
      );
      final top = itemRect(tester, 51).top;
      c.jumpTo(30);
      await tester.pump();
      expect(calls, greaterThan(0));
      expect(itemRect(tester, 51).top, top - 30);
      await tester.drag(find.byType(AnchorListView), const Offset(0, -100));
      await tester.pump();
      expect(c.offset, greaterThan(30));
    });

    testWidgets('can be given to a Scrollbar', (tester) async {
      final c = AnchorListController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Scrollbar(
              controller: c,
              thumbVisibility: true,
              child: AnchorListView.builder(
                controller: c,
                itemCount: 100,
                initialIndex: 50,
                itemBuilder: (_, i) =>
                    SizedBox(height: heightOf(i), child: Text('item $i')),
              ),
            ),
          ),
        ),
      );
      Rect thumb() {
        final rects = <Rect>[];
        expect(
          find.byType(Scrollbar),
          paints..everything((method, args) {
            if (method == #drawRect) {
              rects.add(args.first as Rect);
            }
            return true;
          }),
        );
        // The track comes first, then the thumb.
        return rects.last;
      }

      // The thumb appears after the first frame.
      await tester.pumpAndSettle();
      final middle = thumb();
      expect(middle.center.dy, closeTo(height / 2, height / 4));
      c.jumpToItem(2);
      await tester.pumpAndSettle();
      expect(thumb().top, lessThan(middle.top));
      expect(thumb().top, lessThan(height / 8));
      c.jumpToItem(99);
      await tester.pumpAndSettle();
      expect(thumb().bottom, closeTo(height, 1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('works without a controller and when one is given later', (
      tester,
    ) async {
      await tester.pumpWidget(harness(items: range(0, 100), initialValue: 50));
      await tester.drag(find.byType(AnchorListView), const Offset(0, -100));
      await tester.pumpAndSettle();
      final c = AnchorListController();
      await tester.pumpWidget(
        harness(items: range(0, 100), initialValue: 50, controller: c),
      );
      c.jumpToItem(10);
      await tester.pump();
      expect(itemRect(tester, 10).top, 0);
      await tester.pumpWidget(harness(items: range(0, 100), initialValue: 50));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('position reports', () {
    testWidgets('not reported again when nothing changed', (tester) async {
      final reports = <List<AnchorItemPosition>>[];
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          onPositions: reports.add,
        ),
      );
      expect(reports, hasLength(1));
      await tester.pumpWidget(
        harness(
          items: range(0, 100),
          initialValue: 50,
          onPositions: reports.add,
        ),
      );
      await tester.pump();
      expect(reports, hasLength(1));
      await tester.drag(find.byType(AnchorListView), const Offset(0, -50));
      await tester.pump();
      expect(reports, hasLength(2));
    });

    testWidgets('reported when an item changes its height', (tester) async {
      final reports = <List<AnchorItemPosition>>[];
      var tall = false;
      late StateSetter set;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                set = setState;
                return AnchorListView.builder(
                  itemCount: 100,
                  initialIndex: 50,
                  onPositionsChanged: reports.add,
                  itemBuilder: (_, i) => SizedBox(
                    height: i == 50 && tall ? 200 : 100,
                    child: Text('item $i'),
                  ),
                );
              },
            ),
          ),
        ),
      );
      expect(reports.last.first.trailingEdge, 100 / height);
      set(() => tall = true);
      await tester.pump();
      await tester.pump();
      expect(reports.last.first.trailingEdge, 200 / height);
    });
  });
}

class _Counter extends StatefulWidget {
  const new({super.key, required this.label});

  final String label;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => count++),
      child: SizedBox(height: 60, child: Text('${widget.label}: $count')),
    );
  }
}
