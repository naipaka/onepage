# Widgets

This package provides generic widgets for the application.

## Features

- Loading indicators
- Custom buttons
- Utility widgets

## Getting started

To use this package, add `widgets` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  widgets:
    path: ../widgets/
```

## Usage

Here is an example of how to use the loading indicator widget.

```dart
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Widgets Example'),
        ),
        body: centerLoadingIndicator,
      ),
    );
  }
}
```
