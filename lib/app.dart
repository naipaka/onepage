import 'package:flutter/material.dart';

/// The main application widget.
class App extends StatelessWidget {
  /// Creates the main application widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
