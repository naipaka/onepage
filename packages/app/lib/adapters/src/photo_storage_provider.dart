import 'dart:io';

import 'package:photo_storage/photo_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_storage_provider.g.dart';

/// Creates the photo file storage once at startup.
@Riverpod(keepAlive: true)
Future<PhotoStorage> photoStorageInitializing(Ref ref) => PhotoStorage.create();

/// Provider for the photo file storage.
///
/// After initialization, use this, which can be obtained synchronously.
@Riverpod(keepAlive: true)
PhotoStorage photoStorage(Ref ref) {
  return ref.watch(photoStorageInitializingProvider).requireValue;
}

/// Provider for the file of a stored photo.
@riverpod
File photoFile(Ref ref, String fileName) {
  return ref.watch(photoStorageProvider).file(fileName);
}
