# i18n

This package supports the internationalization and localization of the application. All texts for translating the application's text are defined here.

## Features

- Provides localization support for multiple languages.
- Includes predefined translations for English and Japanese.
- Easy integration with Flutter applications.

## Getting started

To use this package, add `i18n` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  i18n:
    path: ../i18n/
```

## Usage

Here is an example of how to use this package.

```dart
import 'package:flutter/material.dart';
import 'package:i18n/i18n.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return MaterialApp(
      localizationsDelegates: localizationsDelegates,
      supportedLocales: supportedLocales,
      home: Scaffold(
        appBar: AppBar(
          title: Text(t.home.title),
        ),
        body: Center(
          child: Text(t.home.message),
        ),
      ),
    );
  }
}
```

## How to add a new language

To add a new language, create a new YAML file in the `lib/src/i18n` directory. The file name should be the language code, such as `app_en.yaml` or `app_ja.yaml`. The file should contain the translations for the language in the following format:

```yaml
home:
  title: 'Hello, World!'
  message: 'This is a message.'
```
