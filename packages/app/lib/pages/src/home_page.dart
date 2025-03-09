import 'dart:async';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:theme/theme.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';
import '../../gen/assets.gen.dart';
import '../../router/src/app_routes.dart';

/// {@template onepage.HomePage}
/// Home page when the app is opened.
/// {@endtemplate}
class HomePage extends HookConsumerWidget {
  /// {@macro onepage.HomePage}
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;

    // Get the list of dates for the previous month for calendar display.
    final now = useMemoized(() => clock.now());
    // Get the visible date for the calendar.
    final visibleDateState = useMemoized(() => ValueNotifier(now));

    // Create a controller to manage the scroll position of the calendar.
    final scrollCalendarController = useMemoized(ScrollCalendarController.new);

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: visibleDateState,
          builder: (context, value, child) {
            return Text(value.yMMMM(context.locale.languageCode));
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await scrollCalendarController.scrollToToday();
              if (!context.mounted) {
                return;
              }
              showSnackBar(context, message: context.t.home.scrollToToday);
            },
            icon: const Icon(Icons.today_outlined),
          ),
        ],
      ),
      drawer: const _Drawer(),
      body: SafeArea(
        bottom: false,
        child: Consumer(
          builder: (context, ref, child) {
            final asyncDiaries = ref.watch(cachedDiariesProvider);
            final notifier = ref.watch(cachedDiariesProvider.notifier);
            return asyncDiaries.when(
              loading: () => centerLoadingIndicator,
              error:
                  (error, _) => Center(
                    child: Column(
                      children: [
                        Icon(Icons.error, color: colorScheme.error),
                        Text(error.toString()),
                      ],
                    ),
                  ),
              data: (diariesWithDates) {
                final diaries = diariesWithDates.diaries;
                final dates = diariesWithDates.dates;
                return VerticalScrollCalendar(
                  controller: scrollCalendarController,
                  dates: dates,
                  loadMoreOlder: notifier.loadMoreOlder,
                  onVisibleDateChanged: (date) {
                    visibleDateState.value = date;
                  },
                  loadingIndicator: centerLoadingIndicator,
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
                    final diary = diaries.firstWhereOrNull(
                      (e) => DateUtils.isSameDay(e.date, date),
                    );
                    return DiaryListTile(
                      content: diary?.content,
                      save: (content) async {
                        try {
                          if (diary == null) {
                            await notifier.addDiary(
                              date: date,
                              content: content,
                            );
                          } else {
                            await notifier.updateDiary(
                              id: diary.id,
                              content: content,
                            );
                          }
                        } on Object catch (e) {
                          final tracker = ref.read(trackerProvider);
                          unawaited(
                            tracker.recordError(
                              e,
                              StackTrace.current,
                              fatal: true,
                            ),
                          );
                          if (!context.mounted) {
                            return;
                          }
                          showErrorSnackBar(
                            context,
                            message:
                                '${t.home.errorSavingDiary}\n'
                                '${t.home.errorSavingDiarySolution}',
                          );
                        }
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

class _Drawer extends ConsumerWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Assets.icon.image(width: 64, height: 64),
                const Gap(4),
                HeadlineSmallText(
                  t.title,
                  color: context.colorScheme.onSurface,
                ),
              ],
            ),
          ),
          const Gap(8),
          const DashedDivider(dashedHeight: 2, dashedWidth: 2, dashedSpace: 16),
          const Gap(8),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(t.home.title),
            onTap: () {
              final currentRoute = GoRouterState.of(context).path;
              if (currentRoute == HomeRouteData.path) {
                Scaffold.of(context).closeDrawer();
                return;
              }
              const HomeRouteData().go(context);
            },
          ),
          const Gap(8),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(t.home.license),
            onTap: () {
              const LicenseRouteData().go(context);
            },
          ),
          const Gap(8),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(t.home.backup),
            onTap: () {
              const BackupRouteData().go(context);
            },
          ),
        ],
      ),
    );
  }
}
