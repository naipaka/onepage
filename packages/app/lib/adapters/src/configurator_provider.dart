import 'dart:async';

import 'package:configurator/configurator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:update_requester/update_requester.dart';
import 'package:utils/utils.dart';

import 'tracker_provider.dart';

part 'configurator_provider.g.dart';

/// Initialize the [Configurator] and set the default values.
@Riverpod(keepAlive: true)
Future<Configurator> configuratorInitializing(Ref ref) async {
  final tracker = ref.watch(trackerProvider);
  final target = Configurator();
  try {
    await target.fetchAndActivate();
  } on Exception catch (e) {
    logger.severe('Failed to fetch and activate remote config: $e');
    unawaited(tracker.recordError(e, StackTrace.current));
  }
  // Sets default values to be used when the app is offline or
  // cannot fetch updates.
  await target.setDefaults({
    updateRequestKey: updateRequestDefaultValue,
  });
  return target;
}

/// A provider that manages the [Configurator].
@Riverpod(keepAlive: true)
Configurator configurator(Ref ref) {
  return ref.watch(configuratorInitializingProvider).requireValue;
}
