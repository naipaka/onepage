import 'package:flutter/material.dart';

/// {@template widgets.UnfocusOnTap}
/// Widget that allows you to unfocus by tapping the child.
///
/// This widget is useful when you want to unfocus the keyboard or any other
/// focusable widget when tapping outside of it.
/// {@endtemplate}
class UnfocusOnTap extends StatelessWidget {
  /// {@macro widgets.UnfocusOnTap}
  const UnfocusOnTap({
    super.key,
    required this.child,
  });

  /// Widget to be able to unfocus.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Necessary to react even with Padding, etc.
      behavior: HitTestBehavior.opaque,
      onTap: FocusScope.of(context).unfocus,
      child: child,
    );
  }
}
