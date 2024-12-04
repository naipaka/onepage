# Scroll Calendar

A Flutter package for a scrollable calendar widget.

## Features

- Scrollable calendar with vertical scrolling.
- Supports loading past dates incrementally.
- Customizable date item builder and separator builder.
- Scroll to today's date or a specific date with animation.

## Getting started

To use this package, add `scroll_calendar` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  scroll_calendar:
    path: ../scroll_calendar/
```

## Usage

Here is an example of how to use the `VerticalScrollCalendar` widget.

```dart
import 'package:flutter/material.dart';
import 'package:scroll_calendar/scroll_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scroll Calendar Example'),
        ),
        body: CalendarPage(),
      ),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final scrollCalendarController = ScrollCalendarController();

  @override
  Widget build(BuildContext context) {
    return VerticalScrollCalendar(
      controller: scrollCalendarController,
      separatorBuilder: (_, __) => const Divider(),
      dateItemBuilder: (_, date) {
        return ListTile(
          title: Text('${date.year}/${date.month}/${date.day}'),
          onTap: () {
            print('Tapped: $date');
          },
        );
      },
    );
  }
}
```
