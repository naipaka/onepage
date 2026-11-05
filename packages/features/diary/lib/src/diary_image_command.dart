import 'dart:typed_data';

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

  /// Compresses and stores a photo, then adds its diary image entry.
  ///
  /// - [diaryId] - The ID of the diary entry.
  /// - [bytes] - The encoded image picked by the user.
  Future<DiaryImage> addDiaryImage({
    required int diaryId,
    required Uint8List bytes,
  }) async {
    final encoded = await photoEncoder.encode(bytes);
    final fileName = await photoStorage.save(encoded);
    return dbClient.insertDiaryImage(diaryId: diaryId, fileName: fileName);
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
