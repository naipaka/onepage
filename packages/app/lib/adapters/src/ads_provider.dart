import 'package:ads/ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ads_provider.g.dart';

/// Provide an [AppTrackingTransparencyClient] instance.
///
/// {@macro ads.AppTrackingTransparencyClient}
@riverpod
AppTrackingTransparencyClient attClient(Ref ref) {
  return const AppTrackingTransparencyClient();
}

// /// Provide an [AdsConsentClient] instance.
// @riverpod
// AdsConsentClient adsConsentClient(Ref ref) {
//   final flavor = ref.watch(flavorProvider);
//   return AdsConsentClient(
//     isDebug: flavor != Flavor.prod,
//   );
// }
