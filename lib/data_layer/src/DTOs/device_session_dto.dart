import '../helpers.dart';

/// Holds the provider data for the Device Sessions of a customer
///
/// This is basically the DeviceSession from the core-models
/// project with a new name.
class DeviceSessionDTO {
  /// The PIN used to access this device.
  String? accessPin;

  /// The build number of the app installed on this device.
  String? appBuildNumber;

  /// The version number of the app installed on this device.
  String? appVersion;

  /// The carrier this device uses.
  String? carrier;

  /// The customer ID authenticated on this device.
  String? customerId;

  /// The device ID.
  int? deviceId;

  /// The name of the device.
  String? deviceName;

  /// How many times the access pin was entered wrong in a row.
  int? failedAccessPin;

  /// Date this session was last used.
  DateTime? lastActivity;

  /// Date of creation.
  DateTime? dateCreated;

  /// Date this device session will expire.
  DateTime? expiresAt;

  /// The last IP used by this device.
  String? lastIP;

  /// A string with the last location used by this device.
  ///
  /// THe backend seems to be sending 'NA' for a lot of users on this field.
  String? lastLocation;

  /// The current location of this device.
  String? location;

  /// Details of the current location of this device.
  LocationDetailsDTO? locationDetails;

  /// The username used to log in to this session.
  String? loginName;

  /// The model of this device.
  String? model;

  /// The operating system family running on this device.
  String? osFamily;

  /// The browser used by this session.
  String? browser;

  /// The operating system version running on this device.
  String? osVersion;

  /// The resolution of the device.
  String? resolution;

  /// The type of this session.
  SessionTypeDTO? type;

  /// The status of this session.
  SessionStatusDTO? status;

  /// The token used for notifications on this device.
  String? notificationToken;

  /// Returns a text best describing the device session.
  String get displayName {
    if (type == SessionTypeDTO.web) return '$browser on $osFamily';

    if (deviceName != null) return deviceName!;

    if (loginName != null) return loginName!;

    return '';
  }

  ///  Creates a new [DeviceSessionDTO]
  DeviceSessionDTO({
    this.accessPin,
    this.appBuildNumber,
    this.appVersion,
    this.carrier,
    this.customerId,
    this.deviceId,
    this.deviceName,
    this.failedAccessPin,
    this.lastActivity,
    this.dateCreated,
    this.expiresAt,
    this.lastIP,
    this.lastLocation,
    this.location,
    this.locationDetails,
    this.loginName,
    this.model,
    this.osFamily,
    this.osVersion,
    this.resolution,
    this.type,
    this.status,
    this.notificationToken,
  });

  /// Creates a new [DeviceSessionDTO] from the given JSON.
  DeviceSessionDTO.fromJson(Map<String, dynamic> json) {
    accessPin = json['access_pin'];
    appBuildNumber = json['app_build_number'];
    appVersion = json['app_version'];
    carrier = json['carrier'];
    customerId = json['customer_id'];
    deviceId = JsonParser.parseInt(json['device_id']);
    deviceName = json['device_name'];
    failedAccessPin = JsonParser.parseInt(json['failed_access_pin']);
    dateCreated = JsonParser.parseDate(json['ts_created']);
    expiresAt = JsonParser.parseDate(json['expires_at']);
    lastActivity = JsonParser.parseDate(json['last_activity']);
    lastIP = json['last_ip'];
    lastLocation = json['last_location'];
    location = json['location'];
    locationDetails = json['location_details'] != null
        ? LocationDetailsDTO.fromJson(json['location_details'])
        : null;
    loginName = json['login_name'];
    model = json['model'];
    osFamily = json['os_family'];
    browser = json['browser'];
    osVersion = json['os_version'];
    resolution = json['resolution'];
    type = json['type'] != null
        ? SessionTypeDTO(json['type'])
        : SessionTypeDTO.other;
    status = json['status'] != null
        ? SessionStatusDTO(json['status'])
        : SessionStatusDTO.other;
  }

  /// Encodes to a JSON.
  Map<String, dynamic> toJson() {
    final body = <String, dynamic>{};

    if (isNotEmpty(notificationToken)) {
      body['notification_token'] = notificationToken;
    }

    if (isNotEmpty(accessPin)) body['access_pin'] = accessPin;
    if (isNotEmpty(appBuildNumber)) body['app_build_number'] = appBuildNumber;
    if (isNotEmpty(appVersion)) body['app_version'] = appVersion;
    if (isNotEmpty(carrier)) body['carrier'] = carrier;
    if (isNotEmpty(customerId)) body['customer_id'] = customerId;
    if (deviceId != null) body['device_id'] = deviceId;
    if (isNotEmpty(deviceName)) body['device_name'] = deviceName;
    if (failedAccessPin != null) body['failed_access_pin'] = failedAccessPin;
    if (dateCreated != null) body['ts_created'] = dateCreated;
    if (expiresAt != null) body['expires_at'] = expiresAt;
    if (lastActivity != null) body['last_activity'] = lastActivity;
    if (isNotEmpty(lastIP)) body['last_ip'] = lastIP;
    if (isNotEmpty(lastLocation)) body['last_location'] = lastLocation;
    if (isNotEmpty(location)) body['location'] = location;
    if (isNotEmpty(loginName)) body['login_name'] = loginName;
    if (isNotEmpty(model)) body['model'] = model;
    if (isNotEmpty(osFamily)) body['os_family'] = osFamily;
    if (isNotEmpty(osVersion)) body['os_version'] = osVersion;
    if (isNotEmpty(resolution)) body['resolution'] = resolution;
    if (type != null) body['type'] = type!.value;
    if (status != null) body['status'] = status!.value;

    return body;
  }

  /// Creates a list of [DeviceSessionDTO]s from the given JSON list.
  static List<DeviceSessionDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(DeviceSessionDTO.fromJson).toList();
}

/// Holds the type of session.
class SessionTypeDTO extends EnumDTO {
  /// Android device
  static const android = SessionTypeDTO._internal('A');

  /// iPhone device
  static const iphone = SessionTypeDTO._internal('I');

  /// Web browser
  static const web = SessionTypeDTO._internal('W');

  /// Other types of access.
  static const other = SessionTypeDTO._internal('O');

  /// All the available types of sessions.
  static const List<SessionTypeDTO> values = [android, iphone, web, other];

  const SessionTypeDTO._internal(String value) : super.internal(value);

  /// Creates a new [SessionTypeDTO] from the given text.
  factory SessionTypeDTO(String? raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => SessionTypeDTO.other,
      );
}

/// The status of a particular session
class SessionStatusDTO extends EnumDTO {
  /// Active
  static const active = SessionStatusDTO._internal('A');

  /// Inactive
  static const inactive = SessionStatusDTO._internal('I');

  /// Wiped/Terminated
  static const wiped = SessionStatusDTO._internal('W');

  /// Other types of status.
  static const other = SessionStatusDTO._internal('O');

  /// User has logged out.
  static const loggedOut = SessionStatusDTO._internal('L');

  /// All the available status of sessions.
  static const List<SessionStatusDTO> values = [
    active,
    inactive,
    wiped,
    other,
    loggedOut,
  ];

  const SessionStatusDTO._internal(String value) : super.internal(value);

  /// Creates a new [SessionStatusDTO] from the given text.
  factory SessionStatusDTO(String? raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => SessionStatusDTO.other,
      );
}

/// Holds the details of a location.
class LocationDetailsDTO {
  /// The city name.
  final String? city;

  /// The continent name.
  final String? continent;

  /// THe country name.
  final String? country;

  /// The ISO code for the country.
  final String? countryISO;

  /// The latitude.
  final num? latitude;

  /// The longitude.
  final num? longitude;

  /// Creates a new [LocationDetailsDTO].
  LocationDetailsDTO({
    this.city,
    this.continent,
    this.country,
    this.countryISO,
    this.latitude,
    this.longitude,
  });

  /// Creates a new [LocationDetailsDTO] from the given JSON.
  factory LocationDetailsDTO.fromJson(Map<String, dynamic> json) =>
      LocationDetailsDTO(
        city: json['city'],
        continent: json['continent'],
        country: json['country'],
        countryISO: json['country_iso'],
        latitude: JsonParser.parseDouble(json['latitude']),
        longitude: JsonParser.parseDouble(json['longitude']),
      );
}
