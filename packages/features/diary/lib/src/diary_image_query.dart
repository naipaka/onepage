import 'package:db_client/db_client.dart';

/// {@template diary.DiaryImageQuery}
/// A class that defines query methods related to diary images.
///
/// This class provides methods to interact with the diary images database
/// through the provided [DbClient]. It allows for querying diary image
/// entries by diary ID.
/// {@endtemplate}
class DiaryImageQuery {
  /// {@macro diary.DiaryImageQuery}
  ///
  /// The [dbClient] parameter is required and should be an instance
  /// of [DbClient] that will be used to perform database operations.
  const DiaryImageQuery({
    required this.dbClient,
  });

  /// Database client.
  final DbClient dbClient;

  /// Retrieves diary images by diary ID.
  ///
  /// - [diaryId] - The ID of the diary entry.
  Future<List<DiaryImage>> getDiaryImagesByDiaryId({
    required int diaryId,
  }) async {
    return dbClient.getDiaryImagesByDiaryId(diaryId: diaryId);
  }
}
