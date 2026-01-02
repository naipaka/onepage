import 'package:db_client/db_client.dart';

/// {@template diary.DiaryQuery}
/// A class that defines query methods related to diaries.
///
/// This class provides methods to interact with the diary database
/// through the provided [DbClient]. It allows for querying diary
/// entries within a specified date range.
/// {@endtemplate}
class DiaryQuery {
  /// {@macro diary.DiaryQuery}
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

  /// Searches diaries by content.
  ///
  /// - [searchTerm] - The search term to look for in diary content.
  /// - [limit] - The maximum number of results to return.
  /// - [offset] - The number of results to skip.
  Future<List<DiaryEntry>> searchDiaries({
    required String searchTerm,
    int? limit,
    int? offset,
  }) async {
    return dbClient.searchDiaries(
      searchTerm: searchTerm,
      limit: limit,
      offset: offset,
    );
  }

  /// Counts unique days with diary entries containing non-empty content within
  /// a date range.
  ///
  /// - [from] - The start date of the date range.
  /// - [to] - The end date of the date range.
  Future<int> countUniqueDaysWithContentInRange({
    required DateTime from,
    required DateTime to,
  }) async {
    return dbClient.countUniqueDaysWithContentInRange(
      from: from,
      to: to,
    );
  }

  /// Returns a stream of the total count of diary images.
  ///
  /// The stream emits the current count whenever images are added or removed.
  Stream<int> diaryImageCount() {
    return dbClient.watchDiaryImageCount();
  }
}
