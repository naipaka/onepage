import 'dart:async';

import 'package:i18n/i18n.dart';
import 'package:notification_client/notification_client.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:utils/utils.dart';

import 'prefs_client_provider.dart';
import 'tracker_provider.dart';

part 'notification_client_provider.g.dart';

/// Initialize the [NotificationClient] and set up notification system.
@Riverpod(keepAlive: true)
Future<NotificationClient> notificationClientInitializing(Ref ref) async {
  final tracker = ref.watch(trackerProvider);
  final client = NotificationClient.create(
    channelName: t.notification.channelName,
    channelDescription: t.notification.channelDescription,
  );
  try {
    await client.initialize();
  } on Exception catch (e) {
    logger.severe('Failed to initialize NotificationClient: $e');
    unawaited(tracker.recordError(e, StackTrace.current));
  }
  return client;
}

/// {@template onepage.notificationClientProvider}
/// Provider for NotificationClient instance.
/// {@endtemplate}
@Riverpod(keepAlive: true)
NotificationClient notificationClient(Ref ref) {
  return ref.watch(notificationClientInitializingProvider).requireValue;
}

/// {@template notificationPermissionGrantedProvider}
/// Provider for notification permission granted status.
/// {@endtemplate}
@riverpod
Future<bool> notificationPermissionGranted(Ref ref) async {
  final notificationClient = ref.watch(notificationClientProvider);

  // Listen to app lifecycle state changes
  ref.listen(appLifecycleProvider, (_, next) {
    // When app returns to foreground, invalidate permission status
    if (next.isResumed) {
      ref.invalidateSelf();
    }
  });

  return notificationClient.requestPermissions();
}

/// {@template onepage.NotificationScheduler}
/// Notifier that manages notification scheduling based on settings changes.
/// This notifier automatically schedules/reschedules notifications when
/// settings, diary entries, or skip preferences change.
/// {@endtemplate}
@Riverpod(keepAlive: true)
class NotificationScheduler extends _$NotificationScheduler {
  @override
  void build() {
    ref.listen(notificationSettingsProvider, (_, _) => _reschedule());

    unawaited(_reschedule());
  }

  Future<void> _reschedule() async {
    final notificationClient = ref.read(notificationClientProvider);
    final settings = ref.read(notificationSettingsProvider);

    final title = t.notification.notificationTitle;
    final message = t.notification.notificationBody;

    await notificationClient.scheduleNotifications(
      settings,
      title: title,
      message: message,
    );
  }
}
