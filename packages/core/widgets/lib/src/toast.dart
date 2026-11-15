import 'dart:async';

import 'package:material_ui/material_ui.dart';

/// Displays a success toast message.
///
/// The [icon] takes the text color of the toast.
void showSuccessToast(
  BuildContext context, {
  required String title,
  String? description,
  required Widget icon,
}) {
  _Toast.show(
    context,
    type: _ToastType.success,
    title: title,
    description: description,
    icon: icon,
  );
}

/// Displays an error toast message.
void showErrorToast(
  BuildContext context, {
  required String title,
  String? description,
}) {
  _Toast.show(
    context,
    type: _ToastType.error,
    title: title,
    description: description,
    icon: const Icon(Icons.error_outline),
  );
}

enum _ToastType { success, error }

/// {@template widgets._Toast}
/// A message card that appears at the bottom of the screen for a few seconds.
///
/// A new toast replaces the one on screen. The user can swipe it away.
/// {@endtemplate}
class _Toast extends StatefulWidget {
  /// {@macro widgets._Toast}
  const new({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.onClosed,
  });

  /// The toasts on screen, one for each overlay.
  static final _entries = Expando<OverlayEntry>();

  /// How long the toast stays on screen after it appears.
  static const _displayDuration = Duration(seconds: 3);

  /// Inserts a toast into the root overlay in place of the current one.
  static void show(
    BuildContext context, {
    required _ToastType type,
    required String title,
    required String? description,
    required Widget icon,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    _entries[overlay]
      ?..remove()
      ..dispose();

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _Toast(
        type: type,
        title: title,
        description: description,
        icon: icon,
        onClosed: () {
          _entries[overlay] = null;
          entry
            ..remove()
            ..dispose();
        },
      ),
    );
    _entries[overlay] = entry;
    overlay.insert(entry);
  }

  /// Whether the toast reports a success or an error.
  final _ToastType type;

  /// The main message.
  final String title;

  /// The text shown under [title].
  final String? description;

  /// The icon shown before the message.
  final Widget icon;

  /// Called when the toast has left the screen.
  final VoidCallback onClosed;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _offset = Tween(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _timer = Timer(_Toast._displayDuration, _hide);
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _hide() async {
    await _controller.reverse();
    widget.onClosed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final shadowAlpha = theme.brightness == Brightness.light ? 0.12 : 0.35;
    final iconColor = switch (widget.type) {
      _ToastType.success => colorScheme.onSurface,
      _ToastType.error => colorScheme.error,
    };
    final description = widget.description;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: FadeTransition(
              opacity: _controller,
              child: SlideTransition(
                position: _offset,
                child: Semantics(
                  liveRegion: true,
                  child: Dismissible(
                    key: ObjectKey(widget),
                    onDismissed: (_) => widget.onClosed(),
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 64),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(
                                alpha: shadowAlpha,
                              ),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          spacing: 12,
                          children: [
                            IconTheme.merge(
                              data: IconThemeData(color: iconColor),
                              child: widget.icon,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  Text(
                                    widget.title,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  if (description != null)
                                    Text(
                                      description,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
