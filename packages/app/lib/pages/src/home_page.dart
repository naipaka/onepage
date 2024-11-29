import 'package:clock/clock.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:utils/utils.dart';

/// Home page when the app is opened.
class HomePage extends HookConsumerWidget {
  /// [HomePage] constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;

    // Get the list of dates for the previous month for calendar display.
    final now = useMemoized(() => clock.now());
    final datesState = useState(now.datesInMonths(-1, 0));

    // Create a controller to manage the scroll position of the calendar.
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
          dates: datesState.value,
          loadMoreOlder: () {
            datesState.value = [
              // Add the previous month's dates to the beginning of the list.
              ...datesState.value.first.previousMonthDates,
              ...datesState.value,
            ];
          },
          separatorBuilder: (_, __) => const Gap(32),
          dateItemBuilder: (_, date) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DiaryListTile(
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
