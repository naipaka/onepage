# Scroll Calendar

A Flutter package for a scrollable calendar widget.

## Features

- Vertical calendar of consecutive dates in ascending order, starting with today in the middle.
- Asks for older and newer dates when either end of the list is visible, and keeps the visible dates in place when dates are added before them.
- Reports the date in the middle of the viewport.
- Scrolls to today or to a loaded date, and highlights a date.
- Customizable date item builder and separator builder.

## Getting started

To use this package, add `scroll_calendar` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  scroll_calendar:
    path: ../scroll_calendar/
```

## Usage

```dart
final controller = ScrollCalendarController();

VerticalScrollCalendar(
  controller: controller,
  dates: dates, // Consecutive dates, oldest first.
  loadMoreOlder: () => setState(() => dates = [...previousMonth, ...dates]),
  loadMoreNewer: () => setState(() => dates = [...dates, ...nextMonth]),
  onVisibleDateChanged: (date) => setState(() => visibleDate = date),
  loadingIndicator: const CircularProgressIndicator(),
  dateItemBuilder: (_, date) => Text('${date.month}/${date.day}'),
  // The separator above each date except the first one.
  separatorBuilder: (_, date) =>
      date.day == 1 ? const Divider() : const SizedBox(height: 32),
);

// Scrolls to a date, which must be in `dates`.
await controller.scrollToDate(date);
await controller.highlightDate(date);
```
