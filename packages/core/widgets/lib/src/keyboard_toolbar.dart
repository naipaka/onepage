import 'package:flutter/material.dart';

/// A toolbar widget that appears above the keyboard with a dismiss button.
class KeyboardToolbar extends StatelessWidget {
  /// Creates a keyboard toolbar widget.
  const KeyboardToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      color: colorScheme.surface,
      child: Row(
        children: [
          const Spacer(),
          // This button dismisses the keyboard when pressed.
          IconButton(
            onPressed: () => FocusScope.of(context).unfocus(),
            icon: const Icon(Icons.keyboard_hide),
          ),
        ],
      ),
    );
  }
}
