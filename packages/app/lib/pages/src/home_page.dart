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
import 'package:provider_utils/provider_utils.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:theme/theme.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';
import '../../gen/assets.gen.dart';
import '../../router/src/app_routes.dart';
import '../../widgets/widgets.dart';

/// {@template onepage.HomePage}
/// Home page when the app is opened.
/// {@endtemplate}
class HomePage extends HookConsumerWidget {
  /// {@macro onepage.HomePage}
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;

    final haptic = ref.watch(hapticsProvider);

    // Get the list of dates for the previous month for calendar display.
    final now = useMemoized(() => clock.now());
    // Get the visible date for the calendar.
    final visibleDateState = useMemoized(() => ValueNotifier(now));

    // Create a controller to manage the scroll position of the calendar.
    final scrollCalendarController = useMemoized(ScrollCalendarController.new);

    final hasTextFocus = useState(false);
    final showKeyboardToolbar = hasTextFocus.value;

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: visibleDateState,
          builder: (context, value, child) {
            return Text(value.yMMMM(context.locale.languageCode));
          },
        ),
        actions: [
          HapticIconButton(
            onPressed: () async {
              final selectedDate = await showDialog<DateTime>(
                context: context,
                builder: (context) => const _DiaryEntryDatePickerDialog(),
              );
              if (selectedDate == null || !context.mounted) {
                return;
              }

              ref.showLoading();

              // Ensure the selected date is loaded before scrolling
              final notifier = ref.read(cachedDiariesProvider.notifier);

              // Load data until the selected date is available
              var isDateInRange = false;
              while (!isDateInRange) {
                final cachedDiaries = await ref.read(
                  cachedDiariesProvider.future,
                );
                final availableDates = cachedDiaries.dates;
                isDateInRange = availableDates.any(
                  (date) => DateUtils.isSameDay(date, selectedDate),
                );
                if (!isDateInRange) {
                  await notifier.loadMoreOlder();
                } else {
                  break;
                }
              }

              ref.hideLoading();

              // Scroll to selected date
              await scrollCalendarController.scrollToDate(selectedDate);
              // Feedback for successful date selection
              haptic.successFeedback();

              // Highlight the selected date with animation
              await scrollCalendarController.highlightDate(selectedDate);
            },
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      drawer: const _Drawer(),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Consumer(
              builder: (context, ref, child) {
                final asyncDiaries = ref.watch(cachedDiariesProvider);
                final notifier = ref.watch(cachedDiariesProvider.notifier);
                return asyncDiaries.when(
                  loading: () => centerLoadingIndicator,
                  error: (error, _) => Center(
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
                          onChanged: (_) {
                            haptic.textInputFeedback();
                          },
                          onFocusChanged: (hasFocus) async {
                            hasTextFocus.value = hasFocus;
                            if (hasFocus) {
                              await scrollCalendarController.scrollToDate(date);
                            }
                          },
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
                              showErrorToast(
                                context,
                                title: t.home.errorSavingDiary,
                                description: t.home.errorSavingDiarySolution,
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
          if (showKeyboardToolbar)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: KeyboardToolbar(),
            ),
        ],
      ),
    );
  }
}

class _DiaryEntryDatePickerDialog extends ConsumerWidget {
  const _DiaryEntryDatePickerDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = clock.now();

    final diariesWithDates = ref.watch(cachedDiariesProvider).valueOrNull;
    final notifier = ref.watch(cachedDiariesProvider.notifier);

    final diaries = diariesWithDates?.diaries ?? [];
    final dates = diariesWithDates?.dates ?? [];

    final entries = diaries.where((diary) => diary.content.trim().isNotEmpty);
    final entryDates = entries.map((diary) => diary.date).toSet();

    return CalendarDatePickerDialog(
      initialDate: now,
      lastDate: dates.lastOrNull ?? DateTime(now.year, now.month + 1),
      markedDates: entryDates,
      onMonthChanged: (date) async {
        if (dates.any((d) => DateUtils.isSameDay(d, date))) {
          // If the selected month is already in the diary dates, do nothing.
          return;
        }
        // If the selected month is not in the diary dates, load more diaries.
        await notifier.loadMoreOlder();
      },
      cancelLabel: t.home.datePickerCancel,
      confirmLabel: t.home.datePickerConfirm,
    );
  }
}

class _Drawer extends StatelessWidget {
  const _Drawer();

  @override
  Widget build(BuildContext context) {
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
          HapticNavigationListTile(
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
          HapticNavigationListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(t.home.backup),
            onTap: () {
              const BackupRouteData().go(context);
            },
          ),
          const Gap(8),
          HapticNavigationListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              const SettingsRouteData().go(context);
            },
          ),
          const Gap(8),
          HapticNavigationListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(t.home.license),
            onTap: () {
              const LicenseRouteData().go(context);
            },
          ),
        ],
      ),
    );
  }
}
