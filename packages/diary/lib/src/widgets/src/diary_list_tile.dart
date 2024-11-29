import 'package:flutter/material.dart';
import 'package:theme/theme.dart';

/// Diary list tile.
class DiaryListTile extends StatelessWidget {
  /// Creates a diary list tile.
  const DiaryListTile({
    super.key,
    required this.text,
  });

  /// Text of the diary.
  final String text;

  @override
  Widget build(BuildContext context) {
    return AppText.bodyS(text);
  }
}
