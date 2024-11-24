# Update Requester

The `update_requester` package provides functionality to manage application updates. It checks if an update is required and displays a prompt to the user if necessary.

## Features

- Check if an app update is required based on the current version.
- Display a dialog to prompt the user to update the app.
- Integrates with Firebase for configuration management.

## Getting started

To use this package, add `update_requester` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  update_requester:
    path: ../update_requester/
```

## Usage

Here is an example of how to use the `update_requester` package.

```dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:update_requester/update_requester.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Update Requester Example'),
        ),
        body: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final message = ref.watch(updateRequestMessageProvider);
              if (message != null) {
                return UpdateRequestView(message: message);
              }
              return Text('No update required');
            },
          ),
        ),
      ),
    );
  }
}
```
