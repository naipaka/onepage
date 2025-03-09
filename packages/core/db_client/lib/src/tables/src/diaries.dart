import 'package:drift/drift.dart';

/// A class representing the table for managing diary entries.
@DataClassName('Diary')
class Diaries extends Table {
  /// The auto-incrementing primary key.
  ///
  /// This column represents the unique identifier for each diary entry.
  IntColumn get id => integer().autoIncrement()();

  /// The content of the diary entry.
  ///
  /// This column stores the text content of the diary.
  TextColumn get content => text()();

  /// The date of the diary entry.
  ///
  /// This column stores the date associated with the diary entry.
  DateTimeColumn get date => dateTime()();

  /// The creation timestamp of the diary entry.
  ///
  /// This column stores the timestamp when the diary entry was created. It
  /// defaults to the current date and time.
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// The update timestamp of the diary entry.
  ///
  /// This column stores the timestamp when the diary entry was last updated. It
  /// defaults to the current date and time.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
