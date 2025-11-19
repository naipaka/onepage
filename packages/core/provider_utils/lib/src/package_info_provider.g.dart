// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers that need to initialize asynchronously only once at startup.

@ProviderFor(packageInfoInitializing)
const packageInfoInitializingProvider = PackageInfoInitializingProvider._();

/// Providers that need to initialize asynchronously only once at startup.

final class PackageInfoInitializingProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  /// Providers that need to initialize asynchronously only once at startup.
  const PackageInfoInitializingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoInitializingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoInitializingHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return packageInfoInitializing(ref);
  }
}

String _$packageInfoInitializingHash() =>
    r'9e9859b77c365e47475d313f542ee8bf55158c16';

/// Provide metadata for the application.
///
/// After initialization, use this, which can be obtained synchronously.

@ProviderFor(packageInfo)
const packageInfoProvider = PackageInfoProvider._();

/// Provide metadata for the application.
///
/// After initialization, use this, which can be obtained synchronously.

final class PackageInfoProvider
    extends $FunctionalProvider<PackageInfo, PackageInfo, PackageInfo>
    with $Provider<PackageInfo> {
  /// Provide metadata for the application.
  ///
  /// After initialization, use this, which can be obtained synchronously.
  const PackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoHash();

  @$internal
  @override
  $ProviderElement<PackageInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PackageInfo create(Ref ref) {
    return packageInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PackageInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PackageInfo>(value),
    );
  }
}

String _$packageInfoHash() => r'63e706b5fe08a7c0103a837390bbb19e55cf22f2';
