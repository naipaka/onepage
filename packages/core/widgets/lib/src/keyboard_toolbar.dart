import 'package:flutter/material.dart';

/// A toolbar widget that appears above the keyboard with undo/redo and dismiss buttons.
///
/// Wraps the provided child widget and shows a keyboard toolbar when any
/// TextField within the child gains focus.
class KeyboardToolbar extends StatefulWidget {
  /// Creates a keyboard toolbar widget.
  const KeyboardToolbar({
    super.key,
    required this.child,
    this.onDismiss,
  });

  /// The child widget to wrap with keyboard toolbar functionality.
  final Widget child;
  
  /// Called when the keyboard is dismissed via the dismiss button.
  final VoidCallback? onDismiss;

  @override
  State<KeyboardToolbar> createState() => _KeyboardToolbarState();
}

class _KeyboardToolbarState extends State<KeyboardToolbar> {
  late final FocusScopeNode _scope;
  bool _showToolbar = false;

  @override
  void initState() {
    super.initState();
    _scope = FocusScopeNode();
    _scope.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _scope
      ..removeListener(_onFocusChange)
      ..dispose();
    super.dispose();
  }

  void _onFocusChange() {
    final shouldShowToolbar = _scope.hasFocus && _scope.focusedChild != null;
    if (_showToolbar != shouldShowToolbar) {
      setState(() {
        _showToolbar = shouldShowToolbar;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FocusScope(
          node: _scope,
          child: widget.child,
        ),
        if (_showToolbar)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _KeyboardToolbarContent(
              scope: _scope,
              onDismiss: widget.onDismiss,
            ),
          ),
      ],
    );
  }
}

/// The actual toolbar content widget.
class _KeyboardToolbarContent extends StatelessWidget {
  const _KeyboardToolbarContent({
    required this.scope,
    this.onDismiss,
  });

  final FocusScopeNode scope;
  final VoidCallback? onDismiss;

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
                  _TextHistoryActionButton.undo(scope: scope),
                  _TextHistoryActionButton.redo(scope: scope),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                scope.unfocus();
                onDismiss?.call();
              },
              icon: const Icon(Icons.keyboard_hide),
            ),
          ],
        ),
      ),
    );
  }
}

/// Action type for text history buttons.
enum _TextHistoryAction {
  /// Undo action.
  undo,

  /// Redo action.
  redo,
}

/// A button widget that performs undo/redo actions on the currently focused text field.
class _TextHistoryActionButton extends StatelessWidget {
  /// Creates a text history action button.
  const _TextHistoryActionButton._({
    super.key,
    required this.action,
    required this.icon,
    required this.scope,
  });

  /// Creates an undo button.
  const _TextHistoryActionButton.undo({Key? key, required FocusScopeNode scope})
    : this._(
        key: key,
        action: _TextHistoryAction.undo,
        icon: Icons.undo,
        scope: scope,
      );

  /// Creates a redo button.
  const _TextHistoryActionButton.redo({Key? key, required FocusScopeNode scope})
    : this._(
        key: key,
        action: _TextHistoryAction.redo,
        icon: Icons.redo,
        scope: scope,
      );

  /// The action this button performs.
  final _TextHistoryAction action;

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
                _TextHistoryAction.undo =>
                  controller.value.canUndo ? controller.undo : null,
                _TextHistoryAction.redo =>
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
