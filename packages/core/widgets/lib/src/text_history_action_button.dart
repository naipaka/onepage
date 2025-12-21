import 'package:flutter/material.dart';

/// Action type for text history buttons.
enum TextHistoryAction {
  /// Undo action.
  undo,

  /// Redo action.
  redo,
}

/// A button widget that performs undo/redo actions on the currently focused text field.
class TextHistoryActionButton extends StatelessWidget {
  /// Creates a text history action button.
  const TextHistoryActionButton._({
    super.key,
    required this.action,
    required this.icon,
    required this.scope,
  });

  /// Creates an undo button.
  const TextHistoryActionButton.undo({Key? key, required FocusScopeNode scope})
    : this._(
        key: key,
        action: TextHistoryAction.undo,
        icon: Icons.undo,
        scope: scope,
      );

  /// Creates a redo button.
  const TextHistoryActionButton.redo({Key? key, required FocusScopeNode scope})
    : this._(
        key: key,
        action: TextHistoryAction.redo,
        icon: Icons.redo,
        scope: scope,
      );

  /// The action this button performs.
  final TextHistoryAction action;

  /// The icon to display.
  final IconData icon;

  /// The focus scope node to monitor.
  final FocusScopeNode scope;

  /// Gets the current undo controller for the focused text field.
  UndoHistoryController? get _currentController {
    if (!scope.hasFocus) {
      return null;
    }
    final focusedContext = scope.focusedChild?.context;
    if (focusedContext == null) {
      return null;
    }
    final state = focusedContext.findAncestorStateOfType<EditableTextState>();
    return state?.widget.undoController;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FocusManager.instance,
      builder: (context, child) {
        final controller = _currentController;
        if (controller == null) {
          // Return disabled button when no controller is available
          return IconButton(
            onPressed: null,
            icon: Icon(icon),
          );
        }
        return ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            return IconButton(
              onPressed: switch (action) {
                TextHistoryAction.undo =>
                  controller.value.canUndo ? controller.undo : null,
                TextHistoryAction.redo =>
                  controller.value.canRedo ? controller.redo : null,
              },
              icon: Icon(icon),
            );
          },
        );
      },
    );
  }
}
