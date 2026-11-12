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
  /// The [photoEncoder] parameter compresses photos before they are stored.
  /// The [photoStorage] parameter is the storage that holds photo files.
  const new({
    required this.dbClient,
    required this.photoEncoder,
    required this.photoStorage,
  });

  /// Database client.
  final DbClient dbClient;

  /// Encoder that compresses photos.
  final PhotoEncoder photoEncoder;

  /// Storage for photo files.
  final PhotoStorage photoStorage;

  /// Compresses the photo at [path] and returns its stored file name.
  Future<String> storePhoto(String path) async {
    final encoded = await photoEncoder.encode(path);
    return photoStorage.save(encoded);
  }

  /// Adds an image to the diary entry of [date], creating an empty entry
  /// first when the date has none.
  ///
  /// - [date] - The date of the diary entry.
  /// - [fileName] - The file name returned by [storePhoto].
  ///
  /// Returns the diary entry the image was added to and the added image.
  Future<({DiaryEntry entry, DiaryImage image})> addDiaryImage({
    required DateTime date,
    required String fileName,
  }) async {
    final entry =
        await dbClient.getDiaryByDate(date: date) ??
        await dbClient.insertDiary(content: '', date: date);
    final image = await dbClient.insertDiaryImage(
      diaryId: entry.id,
      fileName: fileName,
    );
    return (entry: entry, image: image);
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

  /// Deletes the diary images whose photo data is outside the app.
  ///
  /// They have no photo files to delete.
  Future<void> deleteExternalDiaryImages() {
    return dbClient.deleteExternalDiaryImages();
  }
}
