import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

/// Diary list tile.
class DiaryListTile extends StatelessWidget {
  /// Creates a diary list tile.
  const DiaryListTile({
    super.key,
    required this.content,
  });

  /// Content of the diary.
  final String content;

  @override
  Widget build(BuildContext context) {
    return AppText.bodyS(content);
  }
}
