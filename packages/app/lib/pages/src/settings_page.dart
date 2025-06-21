import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';

import '../../router/src/app_routes.dart';
import '../../widgets/widgets.dart';

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
          children: [
            const Gap(24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BodyLargeText(
                context.t.settings.accessibility,
                fontWeight: FontWeight.w700,
              ),
            ),
            HapticNavigationListTile(
              title: Text(context.t.settings.hapticFeedback),
              subtitle: Text(context.t.settings.vibrationSettings),
              trailing: const Icon(Icons.arrow_forward_ios),
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
