import 'package:db_client/db_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_client_provider.g.dart';

/// Provide a [DbClient] instance.
///
/// {@macro db_client.DbClient}
@Riverpod(keepAlive: true)
DbClient dbClient(Ref ref) => DbClient();

/// Provide a [DbConnection] instance.
///
/// {@macro db_client.Connection}
@Riverpod(keepAlive: true)
DbConnection dbConnection(Ref ref) => DbConnection();
