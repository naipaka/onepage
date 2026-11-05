import 'package:db_client/db_client.dart';
import 'package:photo_storage/photo_storage.dart';

/// {@template diary.DiaryImageCommand}
/// A class that defines methods with side effects related to diary image
/// operations.
/// {@endtemplate}
class DiaryImageCommand {
  /// {@macro diary.DiaryImageCommand}
  ///
  /// The [dbClient] parameter is required and should be an instance
  /// of [DbClient] that will be used to perform database operations.
  /// The [photoStorage] parameter is the storage that holds photo files.
  const new({
    required this.dbClient,
    required this.photoStorage,
  });

  /// Database client.
  final DbClient dbClient;

  /// Storage for photo files.
  final PhotoStorage photoStorage;

  /// Adds a new diary image entry to the database.
  ///
  /// - [diaryId] - The ID of the diary entry.
  /// - [photoId] - The photo ID from the device's photo library.
  Future<DiaryImage> addDiaryImage({
    required int diaryId,
    required String photoId,
  }) async {
    return dbClient.insertDiaryImage(
      diaryId: diaryId,
      photoId: photoId,
    );
  }

  /// Deletes a diary image entry from the database and its photo file.
  ///
  /// - [id] - The ID of the diary image entry to delete.
  Future<void> deleteDiaryImage({required int id}) async {
    final fileName = await dbClient.deleteDiaryImage(id: id);
    if (fileName != null) {
      await photoStorage.delete(fileName);
    }
  }
}
