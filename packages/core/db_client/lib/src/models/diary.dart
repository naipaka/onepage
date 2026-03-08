import 'package:flutter/foundation.dart';

import '../db_client.dart';

/// {@template db_client.Diary}
/// A diary entry with its associated images.
///
/// This class represents the result of joining diary entries with their
/// associated images from the database. It provides a convenient way to
/// work with diary data along with its related images.
/// {@endtemplate}
@immutable
class Diary {
  /// {@macro db_client.Diary}
  const Diary({
    required this.entry,
    this.images = const [],
  });

  /// The diary entry data.
  final DiaryEntry entry;

  /// The list of images associated with this diary entry.
  final List<DiaryImage> images;

  /// Creates a copy of this [Diary] with the given fields replaced with
  /// new values.
  Diary copyWith({
    DiaryEntry? entry,
    List<DiaryImage>? images,
  }) {
    return Diary(
      entry: entry ?? this.entry,
      images: images ?? this.images,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Diary &&
        other.entry == entry &&
        listEquals(other.images, images);
  }

  @override
  int get hashCode => Object.hash(entry, Object.hashAll(images));

  @override
  String toString() => 'Diary(entry: $entry, images: ${images.length} images)';
}
