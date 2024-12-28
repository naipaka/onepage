import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:theme/theme.dart';
import 'package:update_requester/update_requester.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';

/// Callback to be called when initialization is complete.
typedef NullableWidgetBuilder = Widget? Function(BuildContext context);

/// {@template onepage.InitializationPage}
/// Page displayed during the initialization process of the app.
/// {@endtemplate}
class InitializationPage extends ConsumerWidget {
  /// {@macro onepage.InitializationPage}
  const InitializationPage({
    super.key,
    required this.onInitialized,
  });

  /// Callback to be called when initialization is complete.
  final NullableWidgetBuilder onInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(initializationProvider)) {
      AsyncData(isLoading: false) => _InitializedPage(
          onInitialized: onInitialized,
        ),
      AsyncError(:final error) => _ErrorPage(
          error,
          onRetry: () => ref.invalidate(initializationProvider),
        ),
      _ => const _LoadingPage(),
    };
  }
}

class _InitializedPage extends ConsumerWidget {
  const _InitializedPage({required this.onInitialized});

  final NullableWidgetBuilder onInitialized;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final colorScheme = context.colorScheme;

    final updateRequestMessage = ref.watch(updateRequestMessageProvider);
    final isLoading = ref.watch(isLoadingProvider);

    final child = onInitialized(context);

    return Stack(
      children: [
        if (child case final Widget child) child,
        if (isLoading)
          // Display loading indicator.
          ColoredBox(
            color: colorScheme.scrim,
            child: const PopScope(
              canPop: false,
              child: centerLoadingIndicator,
            ),
          ),
        if (updateRequestMessage != null)
          // Display update request.
          ColoredBox(
            color: colorScheme.scrim,
            child: UpdateRequestView(
              title: t.updateRequest.title,
              message: updateRequestMessage,
              buttonText: t.updateRequest.button.updateNow,
              onButtonPressed: () async {
                final platform = defaultTargetPlatform;
                final urlString = switch (platform) {
                  TargetPlatform.android =>
                    'https://play.google.com/store/apps/details?id=com.naipaka.onepage',
                  TargetPlatform.iOS =>
                    'https://apps.apple.com/us/app/one-page-simple-diary/id6738889085',
                  _ => throw UnsupportedError(
                      'Unsupported platform: $platform',
                    ),
                };
                final url = Uri.https(urlString);
                if (await canLaunchUrl(url)) {
                  unawaited(launchUrl(url));
                }
              },
            ),
          ),
      ],
    );
  }
}

class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: centerLoadingIndicator,
    );
  }
}

class _ErrorPage extends StatelessWidget {
  const _ErrorPage(this.error, {required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error.toString(),
              style: textTheme.headlineMedium,
            ),
            const Gap(16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
