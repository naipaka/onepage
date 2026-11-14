import 'package:provider_utils/provider_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'configurator_provider.dart';
import 'db_client_provider.dart';
import 'notification_client_provider.dart';
import 'photo_storage_provider.dart';
import 'prefs_client_provider.dart';

part 'initialization_provider.g.dart';

/// Providers that need to initialize asynchronously only once at startup.
@Riverpod(keepAlive: true)
Future<void> initialization(Ref ref) async {
  // Concurrent initialization
  await Future.wait([
    ref.watch(dbConnectionProvider).ensureDatabaseFileMigration(),
    ref.watch(prefsClientInitializingProvider.future),
    ref.watch(photoStorageInitializingProvider.future),
    ref.watch(packageInfoInitializingProvider.future),
    ref.watch(configuratorInitializingProvider.future),
    ref.watch(notificationClientInitializingProvider.future),
  ]);
  // Schedule notifications
  ref.watch(notificationSchedulerProvider);
}
