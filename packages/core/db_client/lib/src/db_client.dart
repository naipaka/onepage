import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'db_client.steps.dart';
import 'tables/tables.dart';

part 'db_client.g.dart';

/// {@template db_client.DbClient}
/// This class represents the database client and provides methods to interact
/// with the database.
/// {@endtemplate}
@DriftDatabase(tables: [Diaries])
class DbClient extends _$DbClient {
  /// {@macro db_client.DbClient}
  ///
  /// This constructor initializes the database connection using the
  /// [_openConnection] method.
  DbClient([QueryExecutor? e]) : super(e ?? _openConnection());

  /// {@macro db_client.DbClient}
  ///
  /// This constructor allows for dependency injection, making it easier to
  /// test the database operations.
  @visibleForTesting
  DbClient.forTesting(super.e);

  @override
  int get schemaVersion => 2;

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

  /// Migrates the database to the latest version.
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, scheme) async {
          await m.createIndex(scheme.idxDiariesDate);
        },
      ),
    );
  }

  /// Writes the database to a file.
  ///
  /// This method takes a [filePath] as a parameter and writes the database to
  /// the specified file.
  Future<void> writeBackupToFile({required String filePath}) async {
    await customStatement('VACUUM INTO ?', [filePath]);
  }

  /// Adds a diary entry to the database.
  ///
  /// This method takes [content] and [date] as parameters and inserts
  /// a new diary entry into the 'diaries' table.
  /// It returns the inserted diary entry.
  Future<Diary> insertDiary({required String content, required DateTime date}) {
    final diary = DiariesCompanion(content: Value(content), date: Value(date));
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
  Future<int> updateDiary({required int id, required String content}) {
    final query = update(diaries)..where((tbl) => tbl.id.equals(id));
    final diary = DiariesCompanion(content: Value(content));
    return query.write(diary);
  }

  /// Searches diary entries by content.
  ///
  /// This method takes a [searchTerm] parameter and searches for diary entries
  /// that contain the search term in their content. The search is
  /// case-insensitive. Returns a list of [Diary] objects ordered by date in
  /// descending order.
  Future<List<Diary>> searchDiaries({
    required String searchTerm,
    int? limit,
    int? offset,
  }) {
    final query = select(diaries)
      ..where(
        (tbl) => tbl.content.lower().contains(searchTerm.toLowerCase()),
      )
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]);
    if (limit != null) {
      query.limit(limit, offset: offset);
    }
    return query.get();
  }

  /// Counts unique days with diary entries containing non-empty content within
  /// a date range.
  ///
  /// This method takes two [DateTime] objects, [from] and [to], as parameters
  /// and returns the count of unique days that have diary entries with
  /// non-empty content within the specified date range.
  Future<int> countUniqueDaysWithContentInRange({
    required DateTime from,
    required DateTime to,
  }) async {
    final countExpr = countAll();
    final query = selectOnly(diaries)
      ..addColumns([countExpr])
      ..where(
        diaries.date.isBetweenValues(from, to) & 
        diaries.content.isNotValue('') &
        const CustomExpression<bool>("TRIM(content, ' \t\n\r') != ''"),
      );
    
    final result = await query.getSingle();
    return result.read(countExpr) ?? 0;
  }
}
