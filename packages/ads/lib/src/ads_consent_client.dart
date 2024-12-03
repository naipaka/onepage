import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// A base failure for the ads consent client failures.
abstract class AdsContentFailure implements Exception {
  /// [AdsContentFailure] constructor.
  const AdsContentFailure(this.error);

  /// The error which was caught.
  final Object error;
}

/// Thrown when requesting ads consent fails.
class RequestConsentFailure extends AdsContentFailure {
  /// [RequestConsentFailure] constructor.
  const RequestConsentFailure(super.error);

  @override
  String toString() {
    final error = this.error;
    if (error is FormError) {
      return 'RequestConsentFailure: '
          'errorCode: ${error.errorCode}, '
          'message: ${error.message}';
    } else {
      return 'RequestConsentFailure: $error';
    }
  }
}

/// Signature for the content form provider.
typedef ConsentFormProvider = void Function(
  OnConsentFormLoadSuccessListener successListener,
  OnConsentFormLoadFailureListener failureListener,
);

/// A client that handles requesting ads consent on a device.
class AdsConsentClient {
  /// [ConsentInformation] instance to use for requesting consent.
  AdsConsentClient({
    ConsentInformation? adsConsentInformation,
    ConsentFormProvider? adsConsentFormProvider,
    bool isDebug = false,
  })  : _adsConsentInformation =
            adsConsentInformation ?? ConsentInformation.instance,
        _adsConsentFormProvider =
            adsConsentFormProvider ?? ConsentForm.loadConsentForm,
        _isDebug = isDebug;

  final ConsentInformation _adsConsentInformation;
  final ConsentFormProvider _adsConsentFormProvider;
  final bool _isDebug;

  /// Requests the ads consent by presenting the consent form
  /// if user consent is required but not yet obtained.
  ///
  /// Returns true if the consent was determined.
  ///
  /// Throws a [RequestConsentFailure] if an exception occurs.
  Future<bool> requestConsent() {
    final adsConsentDeterminedCompleter = Completer<bool>();

    _adsConsentInformation.requestConsentInfoUpdate(
      ConsentRequestParameters(
        consentDebugSettings: ConsentDebugSettings(
          debugGeography: _isDebug ? DebugGeography.debugGeographyEea : null,
        ),
      ),
      () async {
        try {
          if (await _adsConsentInformation.isConsentFormAvailable()) {
            adsConsentDeterminedCompleter.complete(await _loadConsentForm());
          } else {
            final status = await _adsConsentInformation.getConsentStatus();
            adsConsentDeterminedCompleter.complete(status.isDetermined);
          }
        } on FormError catch (error, stackTrace) {
          _onRequestConsentError(
            error,
            completer: adsConsentDeterminedCompleter,
            stackTrace: stackTrace,
          );
        }
      },
      (error) => _onRequestConsentError(
        error,
        completer: adsConsentDeterminedCompleter,
      ),
    );

    return adsConsentDeterminedCompleter.future;
  }

  Future<bool> _loadConsentForm() async {
    final completer = Completer<bool>();

    _adsConsentFormProvider(
      (consentForm) async {
        final status = await _adsConsentInformation.getConsentStatus();
        if (status.isRequired) {
          consentForm.show(
            (error) async {
              if (error != null) {
                completer.completeError(error, StackTrace.current);
              } else {
                final updatedStatus =
                    await _adsConsentInformation.getConsentStatus();
                completer.complete(updatedStatus.isDetermined);
              }
            },
          );
        } else {
          completer.complete(status.isDetermined);
        }
      },
      (error) => completer.completeError(error, StackTrace.current),
    );

    return completer.future;
  }

  void _onRequestConsentError(
    FormError error, {
    required Completer<bool> completer,
    StackTrace? stackTrace,
  }) =>
      completer.completeError(
        RequestConsentFailure(error),
        stackTrace ?? StackTrace.current,
      );
}

extension on ConsentStatus {
  /// Whether the user has consented to the use of personalized ads
  /// or the consent is not required, e.g. the user is not in the EEA or UK.
  bool get isDetermined =>
      this == ConsentStatus.obtained || this == ConsentStatus.notRequired;

  /// Whether the consent to the user of personalized ads is required.
  bool get isRequired => this == ConsentStatus.required;
}
