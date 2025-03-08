import 'package:db_client/db_client.dart';
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';

@GenerateNiceMocks([
  MockSpec<DbClient>(),
  MockSpec<DbConnection>(),
  MockSpec<PackageInfo>(),
])
void main() {}
