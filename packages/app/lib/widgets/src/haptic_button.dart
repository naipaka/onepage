import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theme/theme.dart';

import '../../adapters/adapters.dart';

/// {@template app.HapticFilledButton}
/// A FilledButton that provides haptic feedback when pressed.
///
/// This widget wraps a standard FilledButton and automatically triggers
/// button tap haptic feedback when the button is pressed.
/// {@endtemplate}
class HapticFilledButton extends ConsumerWidget {
  /// {@macro app.HapticFilledButton}
  const HapticFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  /// Callback called when the button is pressed.
  final VoidCallback onPressed;

  /// The widget to display inside the button.
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final haptics = ref.watch(hapticsProvider);
    return FilledButton(
      onPressed: () {
        haptics.buttonTapFeedback();
        onPressed();
      },
      child: child,
    );
  }
}

/// {@template app.HapticIconButton}
/// An IconButton that provides haptic feedback when pressed.
///
/// This widget wraps a standard IconButton and automatically triggers
/// button tap haptic feedback when the button is pressed.
/// {@endtemplate}
class HapticIconButton extends ConsumerWidget {
  /// {@macro app.HapticIconButton}
  const HapticIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  /// Callback called when the button is pressed.
  final VoidCallback onPressed;

  /// The icon to display in the button.
  final Widget icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final haptics = ref.watch(hapticsProvider);
    return IconButton(
      onPressed: () {
        haptics.buttonTapFeedback();
        onPressed();
      },
      icon: icon,
    );
  }
}

/// {@template app.HapticNavigationListTile}
/// A ListTile that provides haptic feedback when tapped for navigation.
///
/// This widget wraps a standard ListTile and automatically triggers
/// navigation haptic feedback when the tile is tapped.
/// {@endtemplate}
class HapticNavigationListTile extends ConsumerWidget {
  /// {@macro app.HapticNavigationListTile}
  const HapticNavigationListTile({
    super.key,
    required this.onTap,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  /// Callback called when the list tile is tapped.
  final VoidCallback onTap;

  /// The primary content of the list tile.
  final Widget title;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// A widget to display before the title.
  final Widget? leading;

  /// An optional trailing widget, such as an icon.
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final haptics = ref.watch(hapticsProvider);
    return ListTile(
      onTap: () {
        haptics.navigationFeedback();
        onTap();
      },
      title: title,
      subtitle: subtitle,
      subtitleTextStyle: textTheme.labelSmall?.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      leading: leading,
      trailing: trailing,
    );
  }
}
