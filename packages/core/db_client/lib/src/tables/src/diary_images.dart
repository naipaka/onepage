import 'package:drift/drift.dart';

import 'diaries.dart';

/// A class representing the table for managing diary images.
@TableIndex(name: 'idx_diary_images_diary_id', columns: {#diaryId})
@DataClassName('DiaryImage')
class DiaryImages extends Table {
  /// The auto-incrementing primary key.
  ///
  /// This column represents the unique identifier for each diary image entry.
  IntColumn get id => integer().autoIncrement()();

  /// The foreign key referencing the diary entry.
  ///
  /// This column stores the ID of the associated diary entry.
  /// When the referenced diary is deleted, this image entry is also deleted
  /// (CASCADE).
  IntColumn get diaryId =>
      integer().references(Diaries, #id, onDelete: KeyAction.cascade)();

  /// The photo ID from the device's photo library.
  ///
  /// This column stores the platform-specific photo identifier:
  /// - iOS: PHAsset localIdentifier
  /// - Android: MediaStore ID
  TextColumn get photoId => text()();

  /// The creation timestamp of the diary image entry.
  ///
  /// This column stores the timestamp when the diary image entry was created.
  /// It defaults to the current date and time.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The update timestamp of the diary image entry.
  ///
  /// This column stores the timestamp when the diary image entry was last
  /// updated. It defaults to the current date and time.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
