import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../dtos.dart';
import '../helpers.dart';

/// Holds the provider data for the User
///
/// This is basically the User from the core-banking project with a new name.
class UserDTO {
  /// The user id.
  int? id;

  /// The customer id associated to this user.
  String? customerId;

  /// The user's first name.
  String? firstName;

  /// The user's last name.
  String? lastName;

  /// The authentication token to use when making requests to the backend
  /// regarding this user.
  String? token;

  /// The user's e-mail address.
  String? email;

  /// The url to the user profile image.
  String? imageUrl;

  /// The user's mobile phone number.
  String? mobileNumber;

  /// The current status of this user.
  String? status;

  /// Current OB status for this user.
  OBUserStatusDTO? obStatus;

  /// The latest login code associated to this user.
  LoginCodeDTO? code;

  /// The message returned regarding the login status.
  String? message;

  /// The OTP ID.
  int? otpId;

  /// The login name for this user.
  String? username;

  /// The password for this user.
  String? password;

  //PrefAlerts prefAlerts;

  // PrefPfm prefPfm;
  // PrefSettings prefSettings;

  /// The user preferences related to the experience.
  List<ExperiencePreferencesDTO>? experiencePreferences;

  /// The current device id.
  int? deviceId;

  /// A list of all the currencies this user is tracking.
  List<String>? trackedCurrencies;

  /// The permissions associated with this user.
  List<PermissionDTO>? permissions;

  // DeviceSession device;

  /// The applicant id.
  String? applicantId;

  /// The FIDO token.
  String? onfidoToken;

  /// Date of the last log in.
  DateTime? lastLogin;

  /// If can use USSD.
  bool? isUSSDActive;

  /// A list of roles for this user.
  List<String>? role;

  /// The user name formatted for displaying.
  bool? displayUsername;

  /// If should ask for approval on dealing with the vaults.
  bool? vaultsDisclaimerApproval;

  /// The expiry date for the id in text form.
  String? idExpiryDate;

  /// The Know Your Customer expiry date in text form.
  String? kycExpiryDate;

  /// A text with any title warning associated to this user.
  String? warning;

  /// A text with any description of a warning associated to this user.
  String? warningMessage;

  /// A [List<int>] that contains the ids of this user's favorite offers
  List<int>? favoriteOffers;

  /// Preference object holding all the user's preferences
  PreferencesDTO? userPreferences;

  /// Whether or not this user consents to email ads
  bool? hasEmailAds;

  /// Whether or not this user consents to sms ads
  bool? hasSmsAds;

  /// Whether or not the device of this user should be verified on login
  bool? verifyDevice;

  /// The branch this user belongs to.
  String? branch;

  /// Creates a new [UserDTO].
  UserDTO({
    this.customerId,
    this.firstName,
    this.lastName,
    this.token,
    this.code,
    this.message,
    this.experiencePreferences,
    this.deviceId,
    this.trackedCurrencies,
    this.email,
    this.id,
    this.imageUrl,
    this.mobileNumber,
    this.otpId,
    this.password,
    this.permissions,
    this.status,
    this.username,
    // this.device,
    this.applicantId,
    this.onfidoToken,
    this.obStatus,
    this.lastLogin,
    this.isUSSDActive,
    this.role,
    this.displayUsername = true,
    this.vaultsDisclaimerApproval,
    this.idExpiryDate,
    this.kycExpiryDate,
    this.warning,
    this.warningMessage,
    this.favoriteOffers,
    this.userPreferences,
    this.hasEmailAds,
    this.hasSmsAds,
    this.verifyDevice,
    this.branch,
  });

  /// Creates an [UserDTO] from the supplied JSON.
  UserDTO.fromJson(Map<String, dynamic> json) {
    id = json['a_user_id'];
    customerId = json['customer_id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    token = json['token'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    imageUrl = json['image_url'];
    code = LoginCodeDTO.fromRaw(json['code']);
    message = json['message'];
    otpId = json['otp_id'];
    status = json['status'];
    obStatus = OBUserStatusDTO.fromRaw(json['ob_status']);
    userPreferences = PreferencesDTO.fromJson(json);
    hasEmailAds = jsonLookup(json['pref'], ['ad_consent_email']);
    hasSmsAds = jsonLookup(json['pref'], ['ad_consent_sms']);

    // if (jsonLookup(json, ['pref', 'alert']) != null) {
    //   prefAlerts = PrefAlerts.fromJson(jsonLookup(json, ['pref', 'alert']));
    // } else {
    //   prefAlerts = PrefAlerts();
    // }

    trackedCurrencies = [];
    if (jsonLookup(json['pref'], ['tracked_currencies']) != null) {
      trackedCurrencies = (json['pref']['tracked_currencies'] as List)
          .map((e) => e.toString())
          .toList();
    }

    // if (jsonLookup(json, ['pref', 'settings']) != null) {
    //   prefSettings = PrefSettings.fromJson(json['pref']['settings']);
    // }

    applicantId = json['applicant_id'];

    // prefPfm = PrefPfm.fromJson(
    //     jsonLookup<Map<String, dynamic>, String>(json, ['pref', 'pfm'], {}));

    //TODO[AK] UNCOMMENT before merging
    // if (jsonLookup(json, ['pref', 'container_setting']) != null) {
    //   final preferenceList =
    //       jsonLookup(json, ['pref', 'container_setting']) as Map;
    //   experiencePreferences = preferenceList?.entries
    //           ?.map((entry) => ExperiencePreferencesDTO.fromJson(
    //                 experienceId: entry.key,
    //                 json: entry.value,
    //               ))
    //           ?.toList() ??
    //       [];
    // }

    deviceId = json['device_id'];

    permissions = PermissionDTO.fromJsonList(
      List<Map<String, dynamic>>.from(json['permission'] ?? []),
    );

    onfidoToken = json['sdk_token'];
    lastLogin = JsonParser.parseDate(json['ts_last_login']);

    isUSSDActive = _readBlockedChannels(json);
    role = json['role_id'] != null ? List.from(json['role_id']) : null;

    vaultsDisclaimerApproval =
        jsonLookup(json, ['pref', 'vault_disclaimer_approval']) ?? false;
    idExpiryDate = json["id_expiry"];
    kycExpiryDate = json["kyc_expiry"];
    warning = json["warning"];
    warningMessage = json["warning_message"];
    favoriteOffers =
        jsonLookup<List, String>(json, ['pref', 'favorite_offers'], [])
            ?.cast<int>();
    verifyDevice = json['verify_device'] ?? false;
    branch = json['branch'];
  }

  /// Creates a JSON from select data
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (customerId != null) json['customer_id'] = customerId;
    if (username != null) json['username'] = username;
    if (password != null) json['password'] = password;

    return json;
  }

  /// Creates a JSON from select data for posting
  Map<String, dynamic> toJsonPost() {
    final json = <String, dynamic>{};

    json['first_name'] = firstName;
    json['last_name'] = lastName;
    json['mobile_number'] = mobileNumber;
    json['email'] = email;

    //if (device != null) json.addAll(device.toJson());
    if (userPreferences?.language != null) {
      json['Language'] = userPreferences?.language;
    }

    return json;
  }

  /// Returns a list of [UserDTO] from the JSON
  static List<UserDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(UserDTO.fromJson).toList();

  bool _readBlockedChannels(Map<String, dynamic> json) {
    if (json['blocked_channels'] != null) {
      final list = List<Map<String, dynamic>>.from(json['blocked_channels']);
      if (list.isEmpty) return true;
    }
    return false;
  }
}

///
class OBUserStatusDTO extends EnumDTO {
  /// OTP
  static const otp = OBUserStatusDTO._internal('O');

  /// Set password
  static const setPassword = OBUserStatusDTO._internal('P');

  /// Face verification
  static const faceVerification = OBUserStatusDTO._internal('V');

  /// Pending verification
  static const pendingVerification = OBUserStatusDTO._internal('C');

  /// Choose Plan
  static const choosePlan = OBUserStatusDTO._internal('L');

  /// Top-Up
  static const topup = OBUserStatusDTO._internal('T');

  /// Active
  static const active = OBUserStatusDTO._internal('A');

  /// Blocked
  static const blocked = OBUserStatusDTO._internal('B');

  /// All the available OB statuses.
  static const List<OBUserStatusDTO> values = [
    otp,
    setPassword,
    faceVerification,
    pendingVerification,
    choosePlan,
    topup,
    active,
    blocked,
  ];

  const OBUserStatusDTO._internal(String value) : super.internal(value);

  /// Creates a new [OBUserStatusDTO] from the given text.
  static OBUserStatusDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

/// The available login codes
class LoginCodeDTO extends EnumDTO with EquatableMixin {
  /// Password has expired
  static const passwordExpired =
      LoginCodeDTO._internal('login_password_expired');

  /// Should force password change
  static const forceChangePassword =
      LoginCodeDTO._internal('login_status_change_password');

  /// Should reset password
  static const resetPassword = LoginCodeDTO._internal('reset_password');

  /// Invalid credentials
  static const invalidCredentials =
      LoginCodeDTO._internal('login_invalid_credentials');

  /// User is suspended
  static const loginStatusSuspended =
      LoginCodeDTO._internal('login_status_suspended');

  /// User id has expired
  static const idExpired = LoginCodeDTO._internal('id_expired');

  /// KYC has expired
  static const kycExpired = LoginCodeDTO._internal('kyc_expired');

  /// Device limit exceeded
  static const deviceLimitExceeded =
      LoginCodeDTO._internal('device_limit_exceeded');

  /// Calendar is closed.
  static const calendarClosed = LoginCodeDTO._internal('calendar_closed');

  /// All the available values as a list
  static const List<LoginCodeDTO> values = [
    passwordExpired,
    forceChangePassword,
    resetPassword,
    invalidCredentials,
    loginStatusSuspended,
    idExpired,
    kycExpired,
    deviceLimitExceeded,
    calendarClosed,
  ];

  const LoginCodeDTO._internal(String value) : super.internal(value);

  /// Creates a new [LoginCodeDTO] from the given text.
  static LoginCodeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );

  @override
  List<Object?> get props => [value];
}
