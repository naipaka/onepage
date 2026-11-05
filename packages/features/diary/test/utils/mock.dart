import 'package:db_client/db_client.dart';
import 'package:mockito/annotations.dart';
import 'package:photo_storage/photo_storage.dart';

@GenerateNiceMocks([
  MockSpec<DbClient>(),
  MockSpec<PhotoStorage>(),
])
void main() {}
