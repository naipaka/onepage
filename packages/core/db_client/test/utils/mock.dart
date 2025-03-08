import 'package:mockito/annotations.dart';
import 'package:sqlite3/sqlite3.dart';

@GenerateNiceMocks([
  MockSpec<Sqlite3>(),
  MockSpec<Database>(),
])
void main() {}
