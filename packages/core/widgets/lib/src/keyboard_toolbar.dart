import 'package:flutter/material.dart';

/// A toolbar widget that appears above the keyboard with action buttons and
/// dismiss button.
///
/// Wraps the provided child widget and shows a keyboard toolbar when any
/// TextField within the child gains focus.
class KeyboardToolbar extends StatefulWidget {
  /// Creates a keyboard toolbar widget.
  const KeyboardToolbar({
    super.key,
    required this.child,
    required this.actions,
    this.onDismiss,
  });

  /// The child widget to wrap with keyboard toolbar functionality.
  final Widget child;

  /// A function that returns a list of action widgets to display in the
  /// toolbar.
  ///
  /// The function receives the [FocusScopeNode] to enable actions that need
  /// to interact with the focused text field (e.g., undo/redo).
  final List<Widget> Function(FocusScopeNode scope) actions;

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
              actions: widget.actions,
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
    required this.actions,
    this.onDismiss,
  });

  final FocusScopeNode scope;
  final List<Widget> Function(FocusScopeNode scope) actions;
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
                children: actions(scope),
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
