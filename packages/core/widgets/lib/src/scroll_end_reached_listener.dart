import 'package:material_ui/material_ui.dart';

/// {@template widgets.ScrollEndReachedListener}
/// Calls [onEndReached] when less than one viewport of content is left after
/// the scroll position of [child].
///
/// It checks when the position changes and when the content or the viewport
/// changes size, including the first layout. So [onEndReached] can be called
/// many times while the position stays near the end, and the callback
/// decides whether to load anything.
///
/// Only the scrollable nearest to [child] counts. A scrollable nested inside
/// it does not call [onEndReached].
/// {@endtemplate}
class ScrollEndReachedListener extends StatelessWidget {
  /// {@macro widgets.ScrollEndReachedListener}
  const new({
    super.key,
    required this.onEndReached,
    required this.child,
  });

  /// Called when the end of the content is near, or null to call nothing.
  final VoidCallback? onEndReached;

  /// The widget that contains the scrollable.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<Notification>(
      onNotification: (notification) {
        if (notification
            case ScrollNotification(depth: 0, :final metrics) ||
                ScrollMetricsNotification(depth: 0, :final metrics)
            when metrics.extentAfter < metrics.viewportDimension) {
          onEndReached?.call();
        }
        return false;
      },
      child: child,
    );
  }
}
