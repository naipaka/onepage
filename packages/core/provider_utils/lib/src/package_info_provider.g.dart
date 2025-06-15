// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$packageInfoInitializingHash() =>
    r'9e9859b77c365e47475d313f542ee8bf55158c16';

/// Providers that need to initialize asynchronously only once at startup.
///
/// Copied from [packageInfoInitializing].
@ProviderFor(packageInfoInitializing)
final packageInfoInitializingProvider = FutureProvider<PackageInfo>.internal(
  packageInfoInitializing,
  name: r'packageInfoInitializingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$packageInfoInitializingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PackageInfoInitializingRef = FutureProviderRef<PackageInfo>;
String _$packageInfoHash() => r'63e706b5fe08a7c0103a837390bbb19e55cf22f2';

/// Provide metadata for the application.
///
/// After initialization, use this, which can be obtained synchronously.
///
/// Copied from [packageInfo].
@ProviderFor(packageInfo)
final packageInfoProvider = Provider<PackageInfo>.internal(
  packageInfo,
  name: r'packageInfoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$packageInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PackageInfoRef = ProviderRef<PackageInfo>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
