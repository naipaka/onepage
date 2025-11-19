// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: duplicate_ignore, type=lint, implicit_dynamic_parameter, implicit_dynamic_type, implicit_dynamic_method, strict_raw_type

part of 'db_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provide a [DbClient] instance.
///
/// {@macro db_client.DbClient}

@ProviderFor(dbClient)
const dbClientProvider = DbClientProvider._();

/// Provide a [DbClient] instance.
///
/// {@macro db_client.DbClient}

final class DbClientProvider
    extends $FunctionalProvider<DbClient, DbClient, DbClient>
    with $Provider<DbClient> {
  /// Provide a [DbClient] instance.
  ///
  /// {@macro db_client.DbClient}
  const DbClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dbClientHash();

  @$internal
  @override
  $ProviderElement<DbClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DbClient create(Ref ref) {
    return dbClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DbClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DbClient>(value),
    );
  }
}

String _$dbClientHash() => r'0d3ae5cb08dc890911ec54058d256c216459e3a9';

/// Provide a [DbConnection] instance.
///
/// {@macro db_client.Connection}

@ProviderFor(dbConnection)
const dbConnectionProvider = DbConnectionProvider._();

/// Provide a [DbConnection] instance.
///
/// {@macro db_client.Connection}

final class DbConnectionProvider
    extends $FunctionalProvider<DbConnection, DbConnection, DbConnection>
    with $Provider<DbConnection> {
  /// Provide a [DbConnection] instance.
  ///
  /// {@macro db_client.Connection}
  const DbConnectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dbConnectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dbConnectionHash();

  @$internal
  @override
  $ProviderElement<DbConnection> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DbConnection create(Ref ref) {
    return dbConnection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DbConnection value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DbConnection>(value),
    );
  }
}

String _$dbConnectionHash() => r'768f16c324dc661e92c4b83ff7d7fc965599c2c6';
