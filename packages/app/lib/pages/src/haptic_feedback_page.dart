import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';

import '../../adapters/adapters.dart';

/// {@template onepage.HapticFeedbackPage}
/// Haptic feedback settings page.
/// {@endtemplate}
class HapticFeedbackPage extends HookConsumerWidget {
  /// {@macro onepage.HapticFeedbackPage}
  const HapticFeedbackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final haptics = ref.watch(hapticsProvider);
    final textInputHaptic = ref.watch(textInputHapticEnabledProvider);
    final textInputHapticNotifier = ref.watch(
      textInputHapticEnabledProvider.notifier,
    );
    final otherHaptic = ref.watch(otherHapticEnabledProvider);
    final otherHapticNotifier = ref.watch(
      otherHapticEnabledProvider.notifier,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.settings.hapticFeedback),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const Gap(16),
            _HapticSettingsItem(
              title: context.t.settings.textInput,
              subtitle: context.t.settings.textInputDescription,
              value: textInputHaptic,
              onChanged: (value) async {
                // Update the state and persist the change.
                await textInputHapticNotifier.setEnabled(enabled: value);
                // Trigger haptic feedback when toggled.
                await haptics.toggleFeedback();
              },
            ),
            const Gap(16),
            _HapticSettingsItem(
              title: context.t.settings.other,
              subtitle: context.t.settings.otherDescription,
              value: otherHaptic,
              onChanged: (value) async {
                // Update the state and persist the change.
                await otherHapticNotifier.setEnabled(enabled: value);
                // Trigger haptic feedback when toggled.
                await haptics.toggleFeedback();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HapticSettingsItem extends StatelessWidget {
  const _HapticSettingsItem({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
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
        const Gap(24),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: colorScheme.primary,
        ),
      ],
    );
  }
}
