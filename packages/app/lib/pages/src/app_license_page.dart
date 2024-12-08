import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';

/// {@template onepage.AppLicensePage}
/// License page to display the app license.
/// {@endtemplate}
class AppLicensePage extends ConsumerWidget {
  /// {@macro onepage.AppLicensePage}
  const AppLicensePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colorScheme = context.colorScheme;
    final theme = Theme.of(context);

    final now = clock.now();

    final packageInfo = ref.watch(packageInfoProvider);

    return Theme(
      data: theme.copyWith(
        cardColor: colorScheme.surface,
        textTheme: theme.textTheme.apply(
          bodyColor: colorScheme.onSurface,
        ),
      ),
      child: LicensePage(
        applicationName: packageInfo.appName,
        applicationVersion: packageInfo.version,
        applicationIcon: Image.asset(
          'assets/icon.png',
          width: 120,
          height: 120,
        ),
        applicationLegalese: '© ${now.year} ${t.organization}',
      ),
    );
  }
}
