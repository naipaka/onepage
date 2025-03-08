import 'package:backup/backup.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_client_provider.dart';

part 'backup_provider.g.dart';

/// {@macro backup.BackupController}
@riverpod
BackupController backupController(Ref ref) {
  return BackupController(
    dbClient: ref.watch(dbClientProvider),
    packageInfo: ref.watch(packageInfoProvider),
  );
}
