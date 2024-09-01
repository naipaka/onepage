import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Home page when the app is opened.
class HomePage extends HookConsumerWidget {
  /// Creates the home page constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
