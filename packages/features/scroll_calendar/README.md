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

A calendar that loads a month of dates at either end of the list:

```dart
import 'package:material_ui/material_ui.dart';
import 'package:scroll_calendar/scroll_calendar.dart';

void main() {
  runApp(const MaterialApp(home: CalendarPage()));
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final controller = ScrollCalendarController();

  // Last month, this month, and next month, oldest first.
  List<DateTime> dates = DateTime.now().datesInMonths(-1, 1);
  DateTime visibleDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${visibleDate.year}/${visibleDate.month}'),
        actions: [
          IconButton(
            onPressed: controller.scrollToToday,
            icon: const Icon(Icons.today),
          ),
        ],
      ),
      body: VerticalScrollCalendar(
        controller: controller,
        dates: dates,
        loadMoreOlder: () => setState(() {
          dates = [...dates.first.previousMonthDates, ...dates];
        }),
        loadMoreNewer: () => setState(() {
          dates = [...dates, ...dates.last.nextMonthDates];
        }),
        onVisibleDateChanged: (date) => setState(() => visibleDate = date),
        loadingIndicator: const CircularProgressIndicator(),
        dateItemBuilder: (_, date) => Text('Notes of ${date.month}/${date.day}'),
        // The separator above each date except the first one.
        separatorBuilder: (_, date) => date.day == 1
            ? const Divider(height: 64)
            : const SizedBox(height: 32),
      ),
    );
  }
}
```
