import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// {@template ads.AppTrackingTransparencyClient}
/// A client that handles requesting app tracking transparency on a device.
///
/// This client is used to request tracking authorization on a device.
/// {@endtemplate}
class AppTrackingTransparencyClient {
  /// {@macro ads.AppTrackingTransparencyClient}
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
