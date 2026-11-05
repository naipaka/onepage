import 'package:diary/diary.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_client_provider.dart';
import 'photo_storage_provider.dart';

part 'diary_image_provider.g.dart';

/// A provider that creates a [DiaryImageCommand] instance.
///
/// {@macro diary.DiaryImageCommand}
@Riverpod(keepAlive: true)
DiaryImageCommand diaryImageCommand(Ref ref) {
  final dbClient = ref.watch(dbClientProvider);
  final photoStorage = ref.watch(photoStorageProvider);
  return DiaryImageCommand(
    dbClient: dbClient,
    photoEncoder: const PhotoEncoder(),
    photoStorage: photoStorage,
  );
}

/// Whether a picked photo is being saved.
@Riverpod(keepAlive: true)
class DiaryImageSaving extends _$DiaryImageSaving {
  @override
  bool build() => false;

  /// Marks that saving has started.
  void start() {
    state = true;
  }

  /// Marks that saving has finished.
  void finish() {
    state = false;
  }
}
