import 'dart:async';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:db_client/db_client.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:intl/intl.dart';
import 'package:provider_utils/provider_utils.dart';
import 'package:scroll_calendar/scroll_calendar.dart';
import 'package:theme/theme.dart';
import 'package:utils/utils.dart';
import 'package:visibility_detector/visibility_detector.dart';
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

    // Jump to a specified date in the calendar.
    Future<void> jumpToSpecifiedDate(DateTime? date) async {
      if (date == null || !context.mounted) {
        return;
      }

      ref.showLoading();

      // Ensure the selected date is loaded before scrolling.
      final notifier = ref.read(cachedDiariesProvider.notifier);

      // Load data until the selected date is available.
      await Future.doWhile(() async {
        final cachedDiaries = await ref.read(
          cachedDiariesProvider.future,
        );
        final availableDates = cachedDiaries.dates;
        if (availableDates.any((d) => DateUtils.isSameDay(d, date))) {
          return false;
        }
        await notifier.loadMoreOlder();
        return true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        ref.hideLoading();

        // Scroll to selected date.
        await scrollCalendarController.scrollToDate(date);

        // Feedback for successful date selection.
        haptic.successFeedback();

        // Highlight the selected date with animation.
        await scrollCalendarController.highlightDate(date);
      });
    }

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
              final selectedDate = await _SearchDiaryDialog.show(context);
              if (!context.mounted || selectedDate == null) {
                return;
              }
              await jumpToSpecifiedDate(selectedDate);
            },
            icon: const Icon(Icons.search),
          ),
          HapticIconButton(
            onPressed: () async {
              final selectedDate = await _DiaryEntryDatePickerDialog.show(
                context,
                initialDate: visibleDateState.value,
              );
              if (!context.mounted || selectedDate == null) {
                return;
              }
              await jumpToSpecifiedDate(selectedDate);
            },
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      drawer: const _Drawer(),
      body: KeyboardToolbar(
        child: SafeArea(
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
                  // Wrapped with [TextFieldTapRegion] to prevent keyboard
                  // hiding when tapping text fields during scroll.
                  // By wrapping with [TextFieldTapRegion],
                  // the TextField's onTapOutside event will not fire.
                  return TextFieldTapRegion(
                    child: VerticalScrollCalendar(
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
                            if (!hasFocus) {
                              return;
                            }
                            await scrollCalendarController.scrollToDate(
                              date,
                            );
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
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
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
            leading: const Icon(Icons.notifications_outlined),
            title: Text(t.notification.title),
            onTap: () {
              const NotificationsRouteData().go(context);
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

class _DiaryEntryDatePickerDialog extends ConsumerWidget {
  const _DiaryEntryDatePickerDialog({
    required this.initialDate,
  });

  final DateTime initialDate;

  /// Shows a dialog to select a date for a diary entry.
  static Future<DateTime?> show(
    BuildContext context, {
    required DateTime initialDate,
  }) {
    return showDialog<DateTime>(
      context: context,
      builder: (context) {
        return _DiaryEntryDatePickerDialog(
          initialDate: initialDate,
        );
      },
    );
  }

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
      initialDate: initialDate,
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

/// Search dialog for diary entries.
class _SearchDiaryDialog extends HookConsumerWidget {
  /// Creates a search dialog.
  const _SearchDiaryDialog();

  /// Shows a search dialog for diary entries and returns the selected date.
  static Future<DateTime?> show(BuildContext context) async {
    return showDialog<DateTime?>(
      context: context,
      builder: (context) => const _SearchDiaryDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(diarySearchProvider);

    final searchController = useTextEditingController();
    final searchFocusNode = useFocusNode();
    final isSearching = useState(false);

    // Debounce instance.
    final debounce = useMemoized(
      () => Debounce(delay: const Duration(seconds: 1)),
    );

    useEffect(() {
      // Set the previous search term as the initial value.
      searchController.text = searchState.searchTerm;
      searchFocusNode.requestFocus();
      return debounce.dispose;
    }, []);

    Future<void> performSearch() async {
      final trimmedText = searchController.text.trim();
      if (trimmedText.isEmpty || trimmedText.length < 2) {
        // Clear search results if empty or less than 2 characters.
        isSearching.value = false;
        ref.read(diarySearchProvider.notifier).clear();
      } else {
        isSearching.value = true;
        await ref.read(diarySearchProvider.notifier).search(trimmedText);
        isSearching.value = false;
      }
    }

    void onTextChanged(String value) {
      // Execute debounced search (search after 1 second).
      final trimmedValue = value.trim();
      if (trimmedValue.isEmpty || trimmedValue.length < 2) {
        // Clear immediately if empty or less than 2 characters.
        debounce.dispose();
        isSearching.value = false;
        ref.read(diarySearchProvider.notifier).clear();
      } else {
        isSearching.value = true;
        debounce(performSearch);
      }
    }

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600,
          maxHeight: 700,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SearchBar(
              controller: searchController,
              focusNode: searchFocusNode,
              onChanged: onTextChanged,
              onSubmitted: () async {
                debounce.dispose();
                await performSearch();
              },
              isSearching: isSearching.value,
            ),
            const Gap(16),
            Flexible(
              child: _SearchResults(
                searchState: searchState,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends HookWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.isSearching,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onChanged;
  final void Function() onSubmitted;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final hasText = useListenableSelector(
      controller,
      () => controller.text.isNotEmpty,
    );

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(
            Icons.search,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: context.t.search.searchHint,
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              textInputAction: TextInputAction.search,
              onChanged: onChanged,
              onSubmitted: (_) => onSubmitted(),
            ),
          ),
          if (isSearching) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 8),
          ] else if (hasText) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                controller.clear();
                onChanged('');
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.clear,
                  color: colorScheme.surface,
                  size: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ] else
            const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _SearchResults extends ConsumerWidget {
  const _SearchResults({
    required this.searchState,
  });

  final SearchResult searchState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchState.searchTerm.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: context.colorScheme.onSurfaceVariant.withValues(
              alpha: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          BodyLargeText(
            context.t.search.placeholder,
            color: context.colorScheme.onSurfaceVariant.withValues(
              alpha: 0.7,
            ),
          ),
        ],
      );
    }

    if (searchState.diaries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: BodyLargeText(
          context.t.search.noResults,
          color: context.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: searchState.diaries.length + (searchState.hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) {
        if (index == searchState.diaries.length) {
          return _LoadMoreItem(
            onLoadMore: () async {
              await ref.read(diarySearchProvider.notifier).loadMore();
            },
          );
        }

        final diary = searchState.diaries[index];
        return _SearchResultTile(
          diary: diary,
          searchTerm: searchState.searchTerm,
          onTap: () {
            Navigator.of(context).pop(diary.date);
          },
        );
      },
    );
  }
}

class _LoadMoreItem extends StatelessWidget {
  const _LoadMoreItem({required this.onLoadMore});

  final void Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('load_more_search_results'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) {
          onLoadMore();
        }
      },
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.diary,
    required this.searchTerm,
    required this.onTap,
  });

  final Diary diary;
  final String searchTerm;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelMediumText(
                DateFormat.yMd(context.locale.languageCode).format(diary.date),
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              _HighlightedText(
                text: diary.content,
                searchTerm: searchTerm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({
    required this.text,
    required this.searchTerm,
  });

  final String text;
  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    if (searchTerm.isEmpty) {
      return BodyMediumText(text);
    }

    final colorScheme = context.colorScheme;
    // Replace newlines with spaces to make search targets more visible.
    final normalizedText = text
        .replaceAll('\n', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
    final lowerText = normalizedText.toLowerCase();
    final lowerSearchTerm = searchTerm.toLowerCase();

    // Find the first occurrence position of the search term.
    final searchIndex = lowerText.indexOf(lowerSearchTerm);
    if (searchIndex == -1) {
      return BodyMediumText(normalizedText);
    }

    // Extract display text.
    // Total 60 characters regardless of search word length.
    const totalDisplayLength = 60;
    const halfLength = totalDisplayLength ~/ 2;
    // Simple calculation to ensure the search term is centered.
    final startIndex = (searchIndex - halfLength).clamp(
      0,
      normalizedText.length,
    );
    final endIndex = (startIndex + totalDisplayLength).clamp(
      0,
      normalizedText.length,
    );
    final displayText = normalizedText.substring(startIndex, endIndex);

    // Add ellipsis.
    final prefix = startIndex > 0 ? '...' : '';
    final suffix = endIndex < normalizedText.length ? '...' : '';

    // Create spans for highlighting.
    final spans = <TextSpan>[];

    // Add prefix.
    if (prefix.isNotEmpty) {
      spans.add(TextSpan(text: prefix));
    }

    // Search and highlight all matches within displayText.
    final lowerDisplayText = displayText.toLowerCase();
    var currentIndex = 0;

    var matchIndex = lowerDisplayText.indexOf(lowerSearchTerm);
    while (matchIndex != -1) {
      // Text before match.
      if (matchIndex > currentIndex) {
        spans.add(
          TextSpan(
            text: displayText.substring(currentIndex, matchIndex),
          ),
        );
      }

      // Highlighted text.
      final actualMatch = displayText.substring(
        matchIndex,
        matchIndex + lowerSearchTerm.length,
      );
      spans.add(
        TextSpan(
          text: actualMatch,
          style: TextStyle(
            backgroundColor: colorScheme.primaryContainer,
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

      currentIndex = matchIndex + lowerSearchTerm.length;
      matchIndex = lowerDisplayText.indexOf(
        lowerSearchTerm,
        currentIndex,
      );
    }

    // Remaining text.
    if (currentIndex < displayText.length) {
      spans.add(TextSpan(text: displayText.substring(currentIndex)));
    }

    // Add suffix.
    if (suffix.isNotEmpty) {
      spans.add(TextSpan(text: suffix));
    }

    return RichText(
      text: TextSpan(
        children: spans,
        style: context.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
