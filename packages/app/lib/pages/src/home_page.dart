import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:theme/theme.dart';

/// Home page when the app is opened.
class HomePage extends HookConsumerWidget {
  /// [HomePage] constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    final scrollCalendarController = useMemoized(ScrollCalendarController.new);

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: scrollCalendarController.scrollToToday,
            child: Text(t.home.today),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: SafeArea(
        child: VerticalScrollCalendar(
          controller: scrollCalendarController,
          separatorBuilder: (_, __) => const Gap(32),
          dateItemBuilder: (_, date) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _DiaryListTile(
                date: date,
                text: _mockTextList[date.day % 5],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Diary list tile.
class _DiaryListTile extends StatelessWidget {
  const _DiaryListTile({
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

// TODO(naipaka): Remove this mock text list.
final _mockTextList = [
  // For mock text, use the following text.
  // ignore: avoid_hardcoded_japanese
  '春はあけぼの。やうやう白くなりゆく山ぎは、すこしあかりて、紫だちたる 雲のほそくたなびきたる。',
  // For mock text, use the following text.
  // ignore: avoid_hardcoded_japanese
  '夏は夜。月のころはさらなり。やみもなほ、蛍の多く飛びちがひたる。また、 ただ一つ二つなど、ほのかにうち光りて行くもをかし。雨など降るもをかし。',
  // For mock text, use the following text.
  // ignore: avoid_hardcoded_japanese
  '''秋は夕暮れ。夕日のさして山の端いと近うなりたるに、烏の寝どころへ行く とて、三つ四つ、二つ三つなど、飛びいそぐさへあはれなり。まいて雁などの つらねたるが、いと小さく見ゆるはいとをかし。日入りはてて、風の音、虫の 音など、はたいふべきにあらず。''',
  // For mock text, use the following text.
  // ignore: avoid_hardcoded_japanese
  '''冬はつとめて。雪の降りたるはいふべきにもあらず、霜のいと白きも、また さらでもいと寒きに、火など急ぎおこして、炭もて渡るもいとつきづきし。 昼になりて、ぬるくゆるびもていけば、火桶の火も白き灰がちになりてわろし。''',
  '',
];
