import 'package:diary/diary.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'db_client_provider.dart';

part 'diary_image_provider.g.dart';

/// A provider that creates a [DiaryImageCommand] instance.
///
/// {@macro diary.DiaryImageCommand}
@Riverpod(keepAlive: true)
DiaryImageCommand diaryImageCommand(Ref ref) {
  final dbClient = ref.watch(dbClientProvider);
  return DiaryImageCommand(dbClient: dbClient);
}
