import 'package:mocktail/mocktail.dart';
import 'package:sqlite3/sqlite3.dart';

class MockSqlite3 extends Mock implements Sqlite3;

class MockDatabase extends Mock implements Database;
