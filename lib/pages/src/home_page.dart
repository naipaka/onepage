import 'package:flutter/material.dart';

/// Home page when the app is opened.
class HomePage extends StatelessWidget {
  /// Creates the home page constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // TODO(naipaka): Implement the action.
            },
            child: const Text('Today'),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: const Placeholder(),
    );
  }
}
