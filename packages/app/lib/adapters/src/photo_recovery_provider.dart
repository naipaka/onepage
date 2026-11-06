import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:photo_client/photo_client.dart';
import 'package:photo_storage/photo_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_client_provider.dart';
import 'diary_provider.dart';
import 'photo_storage_provider.dart';
import 'prefs_client_provider.dart';

part 'photo_recovery_provider.g.dart';

/// What the user can do about the remaining photos.
enum PhotoRecoveryAction {
  /// Nothing has been checked yet.
  unknown,

  /// Select the folder that holds the photos.
  pickFolder,

  /// Allow photo access in Settings.
  openSettings,

  /// Nothing, because the originals are gone.
  none,
}

/// {@template onepage.PhotoRecoveryState}
/// The progress of recovering photos.
/// {@endtemplate}
class PhotoRecoveryState {
  /// {@macro onepage.PhotoRecoveryState}
  const new({
    this.action = PhotoRecoveryAction.unknown,
    this.progress,
  });

  /// What the user can do about the remaining photos.
  final PhotoRecoveryAction action;

  /// The completed and total photo counts while a recovery is running.
  final (int, int)? progress;

  /// Whether a recovery is running.
  bool get isRunning => progress != null;
}

/// Provides the device photo library.
@riverpod
PhotoLibrary photoLibrary(Ref ref) => const PhotoLibrary();

/// Provides the diary images that are not stored in the app.
///
/// This is not a stream, because a paused stream keeps the database from
/// closing during a restore.
@riverpod
Future<List<DiaryImage>> unmigratedDiaryImages(Ref ref) {
  return ref.watch(dbClientProvider).getUnmigratedDiaryImages();
}

/// A provider that creates a [PhotoRecoveryCommand] instance.
///
/// {@macro diary.PhotoRecoveryCommand}
@riverpod
PhotoRecoveryCommand photoRecoveryCommand(Ref ref) {
  return PhotoRecoveryCommand(
    dbClient: ref.watch(dbClientProvider),
    photoLibrary: ref.watch(photoLibraryProvider),
    photoEncoder: const PhotoEncoder(),
    photoStorage: ref.watch(photoStorageProvider),
  );
}

/// Recovers photos and reports the progress.
@Riverpod(keepAlive: true)
class PhotoRecovery extends _$PhotoRecovery {
  @override
  PhotoRecoveryState build() {
    // A restored database has its own photos to check.
    ref.watch(dbClientProvider);
    return const PhotoRecoveryState();
  }

  /// Recovers what the library can read and decides what the user can do.
  ///
  /// This only runs once for each database unless [retry] is true.
  Future<void> importFromLibrary({bool retry = false}) async {
    if (state.isRunning ||
        (state.action != PhotoRecoveryAction.unknown && !retry)) {
      return;
    }
    final library = ref.read(photoLibraryProvider);
    state = PhotoRecoveryState(action: state.action, progress: (0, 0));
    final access = await library.requestAccess();
    final recovered = access == PhotoLibraryAccess.denied
        ? 0
        : await _run(
            (onProgress) => ref
                .read(photoRecoveryCommandProvider)
                .recoverFromLibrary(onProgress: onProgress),
          );
    final supportsFolder = await library.supportsFolder;
    state = PhotoRecoveryState(
      action: switch (access) {
        _ when supportsFolder => PhotoRecoveryAction.pickFolder,
        PhotoLibraryAccess.full => PhotoRecoveryAction.none,
        _ => PhotoRecoveryAction.openSettings,
      },
    );
    _refresh(recovered);
  }

  /// Lets the user select a folder and recovers the photos in it.
  ///
  /// Returns the number of recovered photos, or null if the user cancels.
  Future<int?> importFromFolder() async {
    final folder = await ref.read(photoLibraryProvider).pickFolder();
    if (folder == null) {
      return null;
    }
    try {
      final recovered = await _run(
        (onProgress) => ref
            .read(photoRecoveryCommandProvider)
            .recoverFromFolder(folder, onProgress: onProgress),
      );
      _refresh(recovered);
      return recovered;
    } finally {
      state = PhotoRecoveryState(action: state.action);
    }
  }

  /// Stops reminding the user about the remaining photos.
  Future<void> dismiss() async {
    await ref
        .read(prefsClientProvider)
        .setPhotoRecoveryDismissed(
          dismissed: true,
        );
    ref.notifyListeners();
  }

  void _refresh(int recovered) {
    ref.invalidate(unmigratedDiaryImagesProvider);
    if (recovered > 0) {
      ref.invalidate(diariesProvider);
    }
  }

  Future<int> _run(
    Future<int> Function(PhotoRecoveryProgress onProgress) recover,
  ) {
    return recover((completed, total) {
      state = PhotoRecoveryState(
        action: state.action,
        progress: (completed, total),
      );
    });
  }
}
