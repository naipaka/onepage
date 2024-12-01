import 'package:db_client/db_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'db_client_provider.g.dart';

/// A provider that creates a [DbClient] instance.
@Riverpod(keepAlive: true)
DbClient dbClient(Ref ref) => DbClient();
