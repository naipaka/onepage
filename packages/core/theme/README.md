# Theme

This package is responsible for the appearance of `ThemeData` and other appearance-related data used in Flutter apps.

## Features

- Provides a consistent theme for the application.
- Includes custom colors and typography.

## Getting started

To use this package, add `theme` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  theme:
    path: ../theme/
```

## Usage

Import the package and use the provided theme data in your Flutter app.

```dart
import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appLightThemeData,
      darkTheme: appDarkThemeData,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Theme Example'),
        ),
        body: Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
```
