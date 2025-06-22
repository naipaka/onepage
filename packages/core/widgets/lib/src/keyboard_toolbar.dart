import 'package:flutter/material.dart';
import 'package:utils/utils.dart';

/// A toolbar widget that appears above the keyboard with undo/redo and dismiss buttons.
class KeyboardToolbar extends StatelessWidget {
  /// Creates a keyboard toolbar widget.
  const KeyboardToolbar({
    super.key,
    this.undoHistoryController,
  });

  /// The undo history controller for managing undo/redo operations.
  final UndoHistoryController? undoHistoryController;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Wrapped with [TextFieldTapRegion] to prevent keyboard
    // hiding when tapping text fields during scroll.
    // By wrapping with [TextFieldTapRegion],
    // the TextField's onTapOutside event will not fire.
    return TextFieldTapRegion(
      child: Container(
        height: 44,
        color: colorScheme.surface,
        child: Row(
          children: [
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (undoHistoryController
                      case final UndoHistoryController controller) ...[
                    ListenableBuilder(
                      listenable: controller,
                      builder: (context, child) {
                        return IconButton(
                          onPressed: controller.value.canUndo
                              ? controller.undo
                              : null,
                          icon: const Icon(Icons.undo),
                        );
                      },
                    ),
                    ListenableBuilder(
                      listenable: controller,
                      builder: (context, child) {
                        return IconButton(
                          onPressed: controller.value.canRedo
                              ? controller.redo
                              : null,
                          icon: const Icon(Icons.redo),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: context.unfocus,
              icon: const Icon(Icons.keyboard_hide),
            ),
          ],
        ),
      ),
    );
  }
}
