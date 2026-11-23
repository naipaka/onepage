# anchor_list_view

A list view that scrolls to any item by its index, including items that are not built yet, and keeps the visible item in place when items are added before it.

## Features

- Jump or animate to any item by its index, at any alignment in the viewport
- Keep the visible items and their states in place when items are inserted or removed before them
- Report the items in the viewport and their positions
- Use the controller as a `ScrollController`, such as with a `Scrollbar`

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  anchor_list_view:
    path: ../../../packages/core/anchor_list_view
```

## Usage

```dart
final controller = AnchorListController();

Scrollbar(
  controller: controller,
  child: AnchorListView.builder(
    controller: controller,
    itemCount: days.length,
    initialIndex: days.indexOf(today),
    initialAlignment: 0.5,
    itemBuilder: (context, index) =>
        DayTile(key: ValueKey(days[index]), day: days[index]),
    // Finds an item again after days are added before it.
    findChildIndexCallback: (key) =>
        key is ValueKey<DateTime> ? days.indexOf(key.value) : null,
    onPositionsChanged: (positions) {
      // The items in the viewport, from top to bottom.
    },
  ),
);

// Moves the item to the top of the viewport.
controller.jumpToItem(index);

// Scrolls to the item, or fades to it when it is far.
await controller.animateToItem(
  index,
  alignment: 0.5,
  duration: const Duration(milliseconds: 800),
  curve: Curves.easeInOut,
);
```
