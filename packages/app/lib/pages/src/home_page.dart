import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../gen/strings.g.dart';

/// Home page when the app is opened.
class HomePage extends HookConsumerWidget {
  /// Creates the home page constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // TODO(naipaka): Implement the action.
            },
            child: Text(t.home.today),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: const Placeholder(),
    );
  }
}
