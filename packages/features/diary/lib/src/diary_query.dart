import 'package:db_client/db_client.dart';

/// A class that defines query methods related to diaries.
///
/// This class provides methods to interact with the diary database
/// through the provided [DbClient]. It allows for querying diary
/// entries within a specified date range.
class DiaryQuery {
  /// Creates an instance of [DiaryQuery].
  ///
  /// The [dbClient] parameter is required and should be an instance
  /// of [DbClient] that will be used to perform database operations.
  const DiaryQuery({
    required this.dbClient,
  });

  /// Database client.
  final DbClient dbClient;

  /// Retrieves diaries from [from] to [to].
  ///
  /// - [from] - The start date of the date range.
  /// - [to] - The end date of the date range.
  Future<List<Diary>> getDiaries({
    required DateTime from,
    required DateTime to,
  }) async {
    return dbClient.getDiaries(
      from: from,
      to: to,
    );
  }
}
