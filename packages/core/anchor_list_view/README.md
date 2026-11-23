# anchor_list_view

A list view that scrolls to any item by its index, including items that are not built yet, and keeps the visible item in place when items are added before it.

## Features

- Jump or animate to any item by its index, at any alignment in the viewport
- Keep the visible items and their states in place when items are inserted or removed before them
- Report the items in the viewport and their positions
- Use the controller as a `ScrollController`, such as with a `Scrollbar`
- Scroll vertically or horizontally, in either text direction

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  anchor_list_view:
    path: ../../../packages/core/anchor_list_view
```

## Usage

A list of days that keeps the visible days in place when earlier days are added, and moves to the first day:

```dart
import 'package:anchor_list_view/anchor_list_view.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const MaterialApp(home: DaysPage()));
}

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  final controller = AnchorListController();
  List<int> days = [for (var day = 1; day <= 30; day++) day];
  String top = '';

  void addEarlierDays() {
    setState(() {
      final first = days.first;
      days = [for (var day = first - 30; day < first; day++) day, ...days];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(top),
        actions: [
          IconButton(onPressed: addEarlierDays, icon: const Icon(Icons.add)),
          IconButton(
            // Fades to the first day when it is far from the visible days.
            onPressed: () => controller.animateToItem(
              0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
            ),
            icon: const Icon(Icons.vertical_align_top),
          ),
        ],
      ),
      body: Scrollbar(
        controller: controller,
        child: AnchorListView.builder(
          controller: controller,
          itemCount: days.length,
          initialIndex: days.length - 1,
          initialAlignment: 0.5,
          itemBuilder: (_, index) => ListTile(
            key: ValueKey(days[index]),
            title: Text('Day ${days[index]}'),
          ),
          // Finds each day again after earlier days are added, so the
          // visible days stay in place.
          findChildIndexCallback: (key) {
            final index = key is ValueKey<int> ? days.indexOf(key.value) : -1;
            return index < 0 ? null : index;
          },
          // The items in the viewport, from top to bottom.
          onPositionsChanged: (positions) => setState(() {
            top = positions.isEmpty ? '' : 'Day ${days[positions.first.index]}';
          }),
        ),
      ),
    );
  }
}
```
