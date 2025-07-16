import 'dart:convert';

import 'package:configurator/configurator.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

import 'models/models.dart';

/// The key for the [UpdateRequest] configuration.
const updateRequestKey = 'update_request';

/// The default value for the [UpdateRequest] configuration.
final String updateRequestDefaultValue = jsonEncode(
  UpdateRequest(version: Version(1, 0, 0), message: '').toJson(),
);

/// {@template update_requester.UpdateRequester}
/// A class responsible for requesting updates.
///
/// This class provides methods to check if an update is
/// required and to retrieve the update message if an update is needed.
/// It uses [Configurator] to fetch configuration data and [PackageInfo]
/// to get the current app version.
/// {@endtemplate}
class UpdateRequester {
  /// {@macro update_requester.UpdateRequester}
  ///
  /// Takes a [Configurator] to fetch configuration data and a [PackageInfo] to
  /// get the current app version.
  const UpdateRequester({
    required Configurator configurator,
    required PackageInfo packageInfo,
  }) : _configurator = configurator,
       _packageInfo = packageInfo;

  /// The [Configurator] used to fetch configuration data.
  final Configurator _configurator;

  /// The [PackageInfo] used to get the current app version.
  final PackageInfo _packageInfo;

  /// Retrieves the [UpdateRequest] configuration.
  ///
  /// This method fetches the update request configuration
  /// using the [Configurator].
  ///
  /// It takes a callback [onConfigUpdated] which is called
  /// whenever the configuration is updated.
  Config<UpdateRequest> getConfig({
    required ValueChanged<UpdateRequest> onConfigUpdated,
  }) {
    return _configurator.getDataConfig(
      updateRequestKey,
      fromJson: UpdateRequest.fromJson,
      onConfigUpdated: onConfigUpdated,
    );
  }

  /// Determines if an update is required and returns the update message if
  /// needed.
  ///
  /// This method compares the current app version with the version specified
  /// in the [UpdateRequest].
  ///
  /// If the current version is less than the required version, it
  /// returns the update message. Otherwise, it returns null.
  String? updateRequestMessage(UpdateRequest updateRequest) {
    final currentVersion = Version.parse(_packageInfo.version);
    if (currentVersion < updateRequest.version) {
      return updateRequest.message;
    }
    return null;
  }
}
