import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// A client that handles requesting app tracking transparency on a device.
class AppTrackingTransparencyClient {
  /// [AppTrackingTransparency] instance to use
  /// for requesting tracking authorization.
  const AppTrackingTransparencyClient();

  /// Request tracking authorization
  Future<void> requestTrackingAuthorization() async {
    // Get tracking status
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      // If tracking status is not determined, show ATT dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
