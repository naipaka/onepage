// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'backup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// {@macro backup.BackupController}

@ProviderFor(backupController)
const backupControllerProvider = BackupControllerProvider._();

/// {@macro backup.BackupController}

final class BackupControllerProvider
    extends
        $FunctionalProvider<
          BackupController,
          BackupController,
          BackupController
        >
    with $Provider<BackupController> {
  /// {@macro backup.BackupController}
  const BackupControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupControllerHash();

  @$internal
  @override
  $ProviderElement<BackupController> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BackupController create(Ref ref) {
    return backupController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BackupController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BackupController>(value),
    );
  }
}

String _$backupControllerHash() => r'9c9b909210ff3370e735dd8e7fd8ef765602723a';
