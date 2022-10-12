import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The available status of the user
enum UserStatus {
  /// Active
  active,

  /// Inactive
  inactive,

  /// Locked
  locked,

  /// Pending
  pending,

  /// Blocked
  blocked,

  /// Expired
  expired,

  /// Suspended
  suspended,

  /// Change password
  changePassword,

  /// This console user calendar is currently closed.
  calendarClosed,
}

/// All the user data needed by the application
class User extends Equatable {
  /// The user's id
  final String id;

  /// The user's username
  ///
  /// Can be null if the application does not use usernames.
  final String? username;

  /// The first name
  final String? firstName;

  /// The last name
  final String? lastName;

  /// The mobile number
  final String? mobileNumber;

  /// The user's image URL
  final String? imageURL;

  /// The user current status
  final UserStatus? status;

  /// A token for the network request
  final String? token;

  /// The user preferences
  final Preferences preferences;

  /// The access pin of the user.
  ///
  /// Can be null if the application does not user access pin.
  final String? accessPin;

  /// Whether or not this customer consents to email ads
  ///
  /// Defaults to `false`
  final bool hasEmailAds;

  /// Whether or not this customer consents to sms ads
  ///
  /// Defaults to `false`
  final bool hasSmsAds;

  /// This customer's device id
  final int? deviceId;

  /// A [List<int>] that contains the ids of this user's favorite offers
  final UnmodifiableListView<int> favoriteOffers;

  /// This user's list of roles.
  final UnmodifiableListView<String> roles;

  /// This user's permissions
  final UserPermissions permissions;

  /// Whether or not the USSD is active for this user.
  ///
  /// Defaults to false.
  final bool isUSSDActive;

  /// Whether or not the device of this user should be verified on login
  ///
  /// Defaults to `false`
  final bool verifyDevice;

  /// The branch this user belongs to.
  final String? branch;

  /// The low balance
  final double? lowBalanceValue;

  final PrefAlerts? prefAlerts;

  /// Returns the full name of the customer.
  String get fullName => [firstName, lastName]
      .where((element) => element != null && element.isNotEmpty)
      .join(' ');

  /// Creates a new [User]
  User({
    required this.id,
    this.username,
    this.imageURL,
    this.status,
    this.token,
    this.mobileNumber,
    this.firstName,
    this.lastName,
    this.accessPin,
    this.deviceId,
    this.lowBalanceValue,
    this.hasEmailAds = false,
    this.hasSmsAds = false,
    this.isUSSDActive = false,
    this.preferences = const Preferences(),
    Iterable<int>? favoriteOffers,
    Iterable<String>? roles,
    this.permissions = const UserPermissions(),
    this.verifyDevice = false,
    this.branch,
    this.prefAlerts,
  })  : favoriteOffers = UnmodifiableListView(favoriteOffers ?? []),
        roles = UnmodifiableListView(roles ?? <String>[]);

  /// Returns a copy of the user modified by the provided data.
  User copyWith({
    String? id,
    String? username,
    String? mobileNumber,
    String? firstName,
    String? lastName,
    UserStatus? status,
    String? token,
    String? accessPin,
    String? imageURL,
    Preferences? userPreferences,
    bool? hasEmailAds,
    bool? hasSmsAds,
    int? deviceId,
    Iterable<int>? favoriteOffers,
    Iterable<String>? roles,
    UserPermissions? permissions,
    bool? isUSSDActive,
    bool? verifyDevice,
    String? branch,
    double? lowBalanceValue,
    PrefAlerts? prefAlerts,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        status: status ?? this.status,
        token: token ?? this.token,
        accessPin: accessPin ?? this.accessPin,
        imageURL: imageURL ?? this.imageURL,
        preferences: userPreferences ?? preferences,
        hasSmsAds: hasSmsAds ?? this.hasSmsAds,
        hasEmailAds: hasEmailAds ?? this.hasEmailAds,
        deviceId: deviceId ?? this.deviceId,
        favoriteOffers: favoriteOffers ?? this.favoriteOffers,
        roles: roles ?? this.roles,
        permissions: permissions ?? this.permissions,
        isUSSDActive: isUSSDActive ?? this.isUSSDActive,
        verifyDevice: verifyDevice ?? this.verifyDevice,
        branch: branch ?? this.branch,
        lowBalanceValue: lowBalanceValue ?? this.lowBalanceValue,
        prefAlerts: prefAlerts ?? this.prefAlerts,
      );

  @override
  List<Object?> get props => [
        id,
        username,
        imageURL,
        mobileNumber,
        firstName,
        lastName,
        status,
        token,
        accessPin,
        preferences,
        hasEmailAds,
        hasSmsAds,
        deviceId,
        favoriteOffers,
        roles,
        permissions,
        verifyDevice,
        branch,
        lowBalanceValue,
        prefAlerts,
      ];
}
