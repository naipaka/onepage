import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:utils/utils.dart';
import 'package:version/version.dart';

import 'update_request_provider.dart';

part 'update_request_message_provider.g.dart';

/// Compares the required Version setting with the actual app version to
/// determine if an update is necessary.
///
/// If an update is required, it provides an update prompt message.
/// If no update is needed, it returns null.
@riverpod
String? updateRequestMessage(Ref ref) {
  final updateRequest = ref.watch(updateRequestStateProvider);
  final currentVersion = Version.parse(ref.watch(packageInfoProvider).version);
  if (currentVersion < updateRequest.version) {
    return updateRequest.message;
  }
  return null;
}
