import 'package:altfire_configurator/altfire_configurator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'configurator_provider.g.dart';

/// A provider that manages the [Configurator].
@Riverpod(keepAlive: true)
Configurator configurator(Ref ref) {
  return Configurator();
}
