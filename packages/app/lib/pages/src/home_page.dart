import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:theme/theme.dart';
import 'package:widgets/widgets.dart';

import 'stub_diaries_state_provider.dart';

/// Home page when the app is opened.
class HomePage extends HookConsumerWidget {
  /// [HomePage] constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;

    // Get the list of dates for the previous month for calendar display.
    final now = useMemoized(() => clock.now());
    final datesState = useMemoized(
      () => ValueNotifier(
        now.datesInMonths(-1, 0)..add(DateTime(now.year, now.month + 1)),
      ),
    );
    // Get the visible date for the calendar.
    final visibleDateState = useMemoized(() => ValueNotifier(now));

    // Create a controller to manage the scroll position of the calendar.
    final scrollCalendarController = useMemoized(ScrollCalendarController.new);

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: visibleDateState,
          builder: (context, value, child) {
            return Text(
              '${value.year}年${value.month}月',
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: scrollCalendarController.scrollToToday,
            icon: const Icon(Icons.today_outlined),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder(
          valueListenable: datesState,
          builder: (context, value, child) {
            final asyncDiaries = ref.watch(stubDiariesStateProvider);
            final diaryNotifier = ref.watch(stubDiariesStateProvider.notifier);
            return VerticalScrollCalendar(
              controller: scrollCalendarController,
              dates: value,
              loadMoreOlder: () {
                datesState.value = [
                  // Add the previous month's dates to the start of the list.
                  ...datesState.value.first.previousMonthDates,
                  ...datesState.value,
                ];
              },
              onVisibleDateChanged: (date) {
                visibleDateState.value = date;
              },
              separatorBuilder: (_, date) {
                if (date.day != 1) {
                  return const Gap(32);
                }
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: DashedDivider(
                    dashedHeight: 2,
                    dashedWidth: 2,
                    dashedSpace: 16,
                  ),
                );
              },
              dateItemBuilder: (_, date) {
                return asyncDiaries.when(
                  loading: () => centerLoadingIndicator,
                  error: (_, __) => Center(
                    child: Icon(
                      Icons.error,
                      color: colorScheme.error,
                    ),
                  ),
                  data: (diaries) {
                    final diary = diaries.firstWhereOrNull(
                      (e) => DateUtils.isSameDay(e.date, date),
                    );
                    return DiaryListTile(
                      content: diary?.content,
                      save: (content) async {
                        await diaryNotifier.save(
                          date: date,
                          content: content,
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
