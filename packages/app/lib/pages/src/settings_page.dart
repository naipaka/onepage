import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';

import '../../router/src/app_routes.dart';

/// {@template onepage.SettingsPage}
/// Settings page to display the app settings.
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro onepage.SettingsPage}
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.settings.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const Gap(24),
            BodyLargeText(
              context.t.settings.accessibility,
              fontWeight: FontWeight.w700,
            ),
            const Gap(16),
            _SettingsItem(
              title: context.t.settings.hapticFeedback,
              subtitle: context.t.settings.vibrationSettings,
              onTap: () {
                const HapticFeedbackRouteData().go(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyLargeText(title),
                const Gap(4),
                LabelSmallText(
                  subtitle,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }
}
