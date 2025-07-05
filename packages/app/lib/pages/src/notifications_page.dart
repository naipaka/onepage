import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n/i18n.dart';
import 'package:notification_client/notification_client.dart';
import 'package:theme/theme.dart';
import 'package:widgets/widgets.dart';

import '../../adapters/adapters.dart';

/// {@template onepage.NotificationsPage}
/// Page for managing notification settings.
/// {@endtemplate}
class NotificationsPage extends HookConsumerWidget {
  /// {@macro onepage.NotificationsPage}
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.notification.title),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _NotificationPermissionStatus(),
              Gap(24),
              _NotificationSettingsList(),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget to display list of notification settings.
class _NotificationSettingsList extends HookConsumerWidget {
  const _NotificationSettingsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final settingsNotifier = ref.watch(notificationSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...settings.map(
          (setting) => _NotificationSettingTile(
            key: ValueKey(setting.id),
            setting: setting,
            onToggle: (enabled) async {
              if (enabled) {
                // Request permission first when enabling notification
                final granted = await ref.read(
                  notificationPermissionGrantedProvider.future,
                );

                if (!granted && context.mounted) {
                  // Permission not granted, don't enable notification
                  showErrorToast(
                    context,
                    title: context.t.notification.permission.deniedMessage,
                  );
                  return;
                }
              }

              await settingsNotifier.toggleNotification(setting.id);
            },
            onTimeChange: (time) async {
              await settingsNotifier.updateNotificationTime(
                setting.id,
                time.hour,
              );
            },
            onRemove: settings.length > 1
                ? () async {
                    await settingsNotifier.removeNotificationTime(setting.id);
                  }
                : null,
          ),
        ),
        if (settings.length < 3)
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(context.t.notification.addTime),
            onTap: () async {
              final time = await _TimePickerSheet.show(
                context,
                initialTime: TimeOfDay.now(),
              );
              if (time == null) {
                return;
              }
              await settingsNotifier.addNotificationTime(time.hour);
            },
          ),
        if (settings.length >= 3)
          Padding(
            padding: const EdgeInsets.all(16),
            child: LabelSmallText(
              context.t.notification.maxTimesReached,
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
      ],
    );
  }
}

/// Widget for individual notification setting.
class _NotificationSettingTile extends StatelessWidget {
  const _NotificationSettingTile({
    super.key,
    required this.setting,
    required this.onToggle,
    required this.onTimeChange,
    this.onRemove,
  });

  final NotificationSetting setting;

  final ValueChanged<bool> onToggle;

  final ValueChanged<TimeOfDay> onTimeChange;

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(setting.id),
      direction: onRemove != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: context.colorScheme.error,
        child: Icon(
          Icons.delete,
          color: context.colorScheme.onPrimary,
        ),
      ),
      confirmDismiss: (direction) async {
        if (onRemove == null) {
          return false;
        }
        return true;
      },
      onDismissed: (direction) {
        onRemove?.call();
      },
      child: ListTile(
        leading: Icon(switch (setting.hour) {
          >= 4 && < 12 => Icons.wb_twilight,
          >= 12 && < 18 => Icons.wb_sunny,
          _ => Icons.nightlight_round,
        }),
        onTap: () async {
          final time = await _TimePickerSheet.show(
            context,
            initialTime: TimeOfDay(hour: setting.hour, minute: 0),
          );
          if (time != null) {
            onTimeChange(time);
          }
        },
        title: Text('${setting.hour.toString().padLeft(2, '0')}:00'),
        trailing: Switch(
          value: setting.isEnabled,
          onChanged: onToggle,
        ),
      ),
    );
  }
}

/// Widget to display notification permission status and request permission.
class _NotificationPermissionStatus extends HookConsumerWidget {
  const _NotificationPermissionStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionState = ref.watch(notificationPermissionGrantedProvider);
    return permissionState.when(
      data: (isGranted) {
        if (isGranted) {
          return const SizedBox.shrink(); // Don't show anything if granted
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.notifications_off,
                    color: context.colorScheme.error,
                  ),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      context.t.notification.permission.deniedTitle,
                      style: context.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const Gap(8),
              Text(
                context.t.notification.permission.deniedMessage,
                style: context.textTheme.bodyMedium,
              ),
              const Gap(16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await AppSettings.openAppSettings(
                      type: AppSettingsType.notification,
                    );
                  },
                  child: Text(
                    context.t.notification.permission.openSettings,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

class _TimePickerSheet extends StatefulWidget {
  const _TimePickerSheet({required this.initialTime});

  final TimeOfDay initialTime;

  static Future<TimeOfDay?> show(
    BuildContext context, {
    required TimeOfDay initialTime,
  }) {
    return showModalBottomSheet<TimeOfDay>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _TimePickerSheet(initialTime: initialTime),
    );
  }

  @override
  State<_TimePickerSheet> createState() => _TimePickerSheetState();
}

class _TimePickerSheetState extends State<_TimePickerSheet> {
  late TimeOfDay _selectedTime;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedTime.hour,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 40,
                diameterRatio: 1.5,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _selectedTime = TimeOfDay(hour: index, minute: 0);
                  });
                },
                physics: const FixedExtentScrollPhysics(),
                controller: _scrollController,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 24,
                  builder: (context, index) {
                    final hour = index;
                    final timeString = '$hour:00';
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectedTime.hour == hour
                            ? context.colorScheme.onSurface.withValues(
                                alpha: 0.1,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        timeString,
                        style: context.textTheme.titleLarge,
                      ),
                    );
                  },
                ),
              ),
            ),
            const Gap(16),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_selectedTime),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
