import 'package:photo_storage/photo_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'photo_storage_provider.g.dart';

/// Provider for the photo file storage.
///
/// This provider must be overridden in main.dart with an initialized instance.
/// By default, it throws UnimplementedError to ensure proper initialization.
@Riverpod(keepAlive: true)
PhotoStorage photoStorage(Ref ref) {
  throw UnimplementedError(
    'PhotoStorage provider must be overridden with an initialized instance '
    'in main.dart',
  );
}
