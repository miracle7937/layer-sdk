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
  /// The PIN used to access this device.
  final String? accessPin;

  /// The build number of the app running on the device
  final String? appBuildNumber;

  /// The version of the app running on the device
  final String? appVersion;

  /// The carrier used by this device
  final String? carrier;

  /// The id of the customer using the device
  final String? customerId;

  /// The id of this device
  final String? deviceId;

  /// The name of this device
  final String? deviceName;

  /// Last activity date
  final DateTime? lastActivity;

  /// Date where this session was created
  final DateTime? created;

  /// Last used IP address
  final String? lastIP;

  /// The last used location
  final String? lastLocation;

  /// Data from the latest location of this device
  final Location? location;

  /// The username used to log into this device
  final String? loginName;

  /// The model of the device
  final String? model;

  /// The operating system family
  final String? osFamily;

  /// The operating system version
  final String? osVersion;

  /// The device resolution
  final Resolution? resolution;

  /// The type of device used on this session
  final SessionType? type;

  /// This session status
  final SessionStatus status;

  /// This session second status if logged out devices are include
  final SessionStatus? secondStatus;

  /// The browser description
  final String? browser;

  /// The date when this session will expire
  final DateTime? expires;

  /// Creates a new [DeviceSession]
  DeviceSession({
    this.accessPin,
    this.deviceId,
    this.deviceName,
    this.status = SessionStatus.other,
    this.secondStatus,
    this.type,
    this.model,
    this.resolution,
    this.carrier,
    this.customerId,
    this.loginName,
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
        accessPin,
        deviceId,
        deviceName,
        status,
        type,
        secondStatus,
        model,
        resolution,
        carrier,
        loginName,
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
    String? accessPin,
    String? deviceId,
    String? deviceName,
    SessionStatus? status,
    SessionStatus? secondStatus,
    SessionType? type,
    String? model,
    Resolution? resolution,
    String? carrier,
    String? loginName,
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
        accessPin: accessPin ?? this.accessPin,
        deviceId: deviceId ?? this.deviceId,
        deviceName: deviceName ?? this.deviceName,
        status: status ?? this.status,
        secondStatus: secondStatus ?? this.secondStatus,
        type: type ?? this.type,
        model: model ?? this.model,
        resolution: resolution ?? this.resolution,
        carrier: carrier ?? this.carrier,
        loginName: loginName ?? this.loginName,
        appVersion: appVersion ?? this.appVersion,
        appBuildNumber: appBuildNumber ?? this.appBuildNumber,
        osFamily: osFamily ?? this.osFamily,
        osVersion: osVersion ?? this.osVersion,
        browser: browser ?? this.browser,
        lastIP: lastIP ?? this.lastIP,
        lastLocation: lastLocation ?? this.lastLocation,
        created: created ?? this.created,
        expires: expires ?? this.expires,
        lastActivity: lastActivity ?? this.lastActivity,
      );
}
