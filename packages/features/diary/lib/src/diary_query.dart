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
  const new({
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

  /// {@template diary.DiaryQuery.minSearchTermLength}
  /// The minimum length of a search term that [searchDiaries] is used with.
  ///
  /// A shorter term matches too many diaries to be useful.
  /// {@endtemplate}
  int get minSearchTermLength => 2;

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

  /// Searches the diaries of [ids] by content, as [searchDiaries] does.
  ///
  /// Returns the diaries in no particular order.
  ///
  /// - [ids] - The IDs of the diaries to search.
  /// - [searchTerm] - The search term to look for in diary content.
  Future<List<DiaryEntry>> searchDiariesByIdIn({
    required Iterable<int> ids,
    required String searchTerm,
  }) {
    return dbClient.searchDiariesByIdIn(ids: ids, searchTerm: searchTerm);
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

  /// Retrieves the diary images whose photo data is outside the app.
  Future<List<DiaryImage>> getExternalDiaryImages() {
    return dbClient.getExternalDiaryImages();
  }
}
