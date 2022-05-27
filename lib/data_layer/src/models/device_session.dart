import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The available status of a session
enum SessionStatus {
  /// Active
  active,

  /// Inactive
  inactive,

  /// Wiped
  wiped,

  /// Logged out
  loggedOut,

  /// Other
  other,
}

/// The type of the session
enum SessionType {
  /// Android phone/tablet
  android,

  /// iOS phone/tablet
  iOS,

  /// Web browser
  web,

  /// Other
  other,
}

/// Keeps the data for the session of a user on a device
class DeviceSession extends Equatable {
  /// The id of this device
  final String? deviceId;

  /// The name of this device
  final String? deviceName;

  /// This session status
  final SessionStatus status;

  /// The type of device used on this session
  final SessionType? type;

  /// The model of the device
  final String? model;

  /// The device resolution
  final Resolution? resolution;

  /// The carrier used by this device
  final String? carrier;

  /// The username used to log into this device
  final String? login;

  /// The version of the app running on the device
  final String? appVersion;

  /// The build number of the app running on the device
  final String? appBuildNumber;

  /// The operating system family
  final String? osFamily;

  /// The operating system version
  final String? osVersion;

  /// The browser description
  final String? browser;

  /// Last used IP address
  final String? lastIP;

  /// The last used location
  final String? lastLocation;

  /// Data from the latest location of this device
  final Location? location;

  /// Date where this session was created
  final DateTime? created;

  /// The date when this session will expire
  final DateTime? expires;

  /// Last activity date
  final DateTime? lastActivity;

  /// Creates a new [DeviceSession]
  DeviceSession({
    this.deviceId,
    this.deviceName,
    this.status = SessionStatus.other,
    this.type,
    this.model,
    this.resolution,
    this.carrier,
    this.login,
    this.appVersion,
    this.appBuildNumber,
    this.osFamily,
    this.osVersion,
    this.browser,
    this.lastIP,
    this.lastLocation,
    this.location,
    this.created,
    this.expires,
    this.lastActivity,
  });

  @override
  List<Object?> get props => [
        deviceId,
        deviceName,
        status,
        type,
        model,
        resolution,
        carrier,
        login,
        appVersion,
        appBuildNumber,
        osFamily,
        osVersion,
        browser,
        lastIP,
        lastLocation,
        location,
        created,
        expires,
        lastActivity,
      ];

  /// Creates a copy of this DeviceSession with different values
  DeviceSession copyWith({
    String? deviceId,
    String? deviceName,
    SessionStatus? status,
    SessionType? type,
    String? model,
    Resolution? resolution,
    String? carrier,
    String? login,
    String? appVersion,
    String? appBuildNumber,
    String? osFamily,
    String? osVersion,
    String? browser,
    String? lastIP,
    String? lastLocation,
    Location? location,
    DateTime? created,
    DateTime? expires,
    DateTime? lastActivity,
  }) =>
      DeviceSession(
        deviceId: deviceId ?? this.deviceId,
        deviceName: deviceName ?? this.deviceName,
        status: status ?? this.status,
        type: type ?? this.type,
        model: model ?? this.model,
        resolution: resolution ?? this.resolution,
        carrier: carrier ?? this.carrier,
        login: login ?? this.login,
        appVersion: appVersion ?? this.appVersion,
        appBuildNumber: appBuildNumber ?? this.appBuildNumber,
        osFamily: osFamily ?? this.osFamily,
        osVersion: osVersion ?? this.osVersion,
        browser: browser ?? this.browser,
        lastIP: lastIP ?? this.lastIP,
        lastLocation: lastLocation ?? this.lastLocation,
        location: location ?? this.location,
        created: created ?? this.created,
        expires: expires ?? this.expires,
        lastActivity: lastActivity ?? this.lastActivity,
      );
}
