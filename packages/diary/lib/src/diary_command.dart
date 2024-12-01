import 'package:db_client/db_client.dart';

/// A class that defines methods with side effects related to diary operations.
class DiaryCommand {
  /// Creates an instance of [DiaryCommand].
  ///
  /// The [dbClient] parameter is required and should be an instance
  /// of [DbClient] that will be used to perform database operations.
  const DiaryCommand({
    required this.dbClient,
  });

  /// Database client.
  final DbClient dbClient;

  /// Adds a new diary entry to the database.
  ///
  /// - [content] - The content of the diary entry.
  /// - [date] - The date of the diary entry.
  Future<void> addDiary({
    required String content,
    required DateTime date,
  }) async {
    await dbClient.insertDiary(
      content: content,
      date: date,
    );
  }

  /// Updates an existing diary entry in the database.
  ///
  /// - [id] - The ID of the diary entry to update.
  /// - [content] - The new content of the diary entry.
  Future<void> updateDiary({
    required int id,
    required String content,
  }) async {
    await dbClient.updateDiary(
      id: id,
      content: content,
    );
  }
}
