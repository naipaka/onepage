import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i18n/i18n.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';

/// Diary list tile.
class DiaryListTile extends StatelessWidget {
  /// Creates a diary list tile.
  const DiaryListTile({
    super.key,
    required this.date,
    this.text,
  });

  /// Date of the diary.
  final DateTime date;

  /// Text of the diary.
  final String? text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final dateColor = date.isToday ? colors.primary : colors.textMain;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AppText.bodySBold(
              '${date.year}',
              color: dateColor,
            ),
            AppText.bodyLBold(
              date.month.toString().padLeft(2, '0'),
              color: dateColor,
            ),
            AppText.bodyLBold(
              date.day.toString().padLeft(2, '0'),
              color: dateColor,
            ),
            AppText.bodySBold(
              date.shortWeekday(context.locale.languageCode),
              color: dateColor,
            ),
          ],
        ),
        const Gap(16),
        if (text case final String text)
          Expanded(
            child: AppText.bodyS(text),
          )
        else
          const Spacer(),
      ],
    );
  }
}
