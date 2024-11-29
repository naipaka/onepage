import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import 'tables/tables.dart';

part 'db_client.g.dart';

/// This class represents the database client and provides methods to interact
/// with the database.
@DriftDatabase(
  tables: [
    Diaries,
  ],
)
class DbClient extends _$DbClient {
  /// Creates an instance of [DbClient].
  ///
  /// This constructor initializes the database connection using the
  /// [_openConnection] method.
  DbClient() : super(_openConnection());

  /// Creates an instance of [DbClient] for testing purposes.
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
  /// database. The database is named 'onepage.db'.
  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'onepage.db');
  }

  /// Adds a diary entry to the database.
  ///
  /// This method takes a [DiariesCompanion] object as a parameter and inserts
  /// it into the 'diaries' table. It returns the ID of the inserted row.
  Future<int> insertDiary(DiariesCompanion diary) =>
      into(diaries).insert(diary);

  /// Retrieves diary entries from the database within a specified date range.
  ///
  /// This method takes two [DateTime] objects, [from] and [to], as parameters
  /// and returns a list of [Diary] objects that fall within the specified date
  /// range.
  Future<List<Diary>> getDiaries(DateTime from, DateTime to) {
    final query = select(diaries)
      ..where((tbl) => tbl.date.isBetweenValues(from, to));
    return query.get();
  }

  /// Updates a diary entry in the database.
  ///
  /// This method takes an integer [id] and a [DiariesCompanion] object as
  /// parameters. It updates the diary entry with the specified ID using the
  /// provided [DiariesCompanion] object.
  /// It returns the number of rows affected.
  Future<int> updateDiary(int id, DiariesCompanion diary) {
    final query = update(diaries)..where((tbl) => tbl.id.equals(id));
    return query.write(diary);
  }
}
