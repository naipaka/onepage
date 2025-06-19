import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';

/// {@template onepage.HapticFeedbackPage}
/// Haptic feedback settings page.
/// {@endtemplate}
class HapticFeedbackPage extends HookWidget {
  /// {@macro onepage.HapticFeedbackPage}
  const HapticFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(naipaka): Implement haptic feedback settings
    final textInputHaptic = useState(true);
    final otherHaptic = useState(true);
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
              value: textInputHaptic.value,
              onChanged: (value) {
                textInputHaptic.value = value;
                // TODO(naipaka): Implement text input haptic feedback setting
                // TODO(naipaka): run haptic feedback
              },
            ),
            const Gap(16),
            _HapticSettingsItem(
              title: context.t.settings.other,
              subtitle: context.t.settings.otherDescription,
              value: otherHaptic.value,
              onChanged: (value) {
                otherHaptic.value = value;
                // TODO(naipaka): Implement other haptic feedback setting
                // TODO(naipaka): run haptic feedback
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
