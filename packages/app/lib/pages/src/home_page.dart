import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
          separatorBuilder: (_, __) => const Divider(),
          dateItemBuilder: (_, date) {
            return ListTile(
              title: Text('${date.year}/${date.month}/${date.day}'),
              onTap: () {
                logger.finest('Tapped: $date');
              },
            );
          },
        ),
      ),
    );
  }
}
