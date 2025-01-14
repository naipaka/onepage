import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/tables.dart';

part 'db_client.g.dart';

/// {@template db_client.DbClient}
/// This class represents the database client and provides methods to interact
/// with the database.
/// {@endtemplate}
@DriftDatabase(
  tables: [
    Diaries,
  ],
)
class DbClient extends _$DbClient {
  /// {@macro db_client.DbClient}
  ///
  /// This constructor initializes the database connection using the
  /// [_openConnection] method.
  DbClient() : super(_openConnection());

  /// {@macro db_client.DbClient}
  ///
  /// This constructor allows for dependency injection, making it easier to
  /// test the database operations.
  @visibleForTesting
  DbClient.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  /// Opens a connection to the database.
  ///
  /// This method returns a [QueryExecutor] that is used to interact with the
  /// database. The database is named 'onepage'.
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'onepage',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  /// Adds a diary entry to the database.
  ///
  /// This method takes [content] and [date] as parameters and inserts
  /// a new diary entry into the 'diaries' table.
  /// It returns the inserted diary entry.
  Future<Diary> insertDiary({
    required String content,
    required DateTime date,
  }) {
    final diary = DiariesCompanion(
      content: Value(content),
      date: Value(date),
    );
    return into(diaries).insertReturning(diary);
  }

  /// Retrieves diary entries from the database within a specified date range.
  ///
  /// This method takes two [DateTime] objects, [from] and [to], as parameters
  /// and returns a list of [Diary] objects that fall within the specified date
  /// range.
  Future<List<Diary>> getDiaries({
    required DateTime from,
    required DateTime to,
  }) {
    final query = select(diaries)
      ..where((tbl) => tbl.date.isBetweenValues(from, to));
    return query.get();
  }

  /// Updates a diary entry in the database.
  ///
  /// This method takes an integer [id] and [content] as parameters.
  /// It updates the diary with the specified ID using the provided content.
  /// It returns the number of rows affected.
  Future<int> updateDiary({
    required int id,
    required String content,
  }) {
    final query = update(diaries)..where((tbl) => tbl.id.equals(id));
    final diary = DiariesCompanion(
      content: Value(content),
    );
    return query.write(diary);
  }
}
