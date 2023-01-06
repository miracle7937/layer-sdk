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

/// All the fields that can be used to sort users in a list.
enum UserSort {
  /// Id.
  id,

  /// Username.
  username,

  ///Agent customer id
  agentCustomerId,

  /// Name.
  name,

  /// Email.
  email,

  /// Mobile phone number.
  mobile,

  /// Status.
  status,

  /// Role.
  role,

  /// Registration date.
  registered,
}

/// All the user data needed by the application
class User extends Equatable {
  /// The user's id
  final String id;

  /// The customer id
  final String? customerId;

  /// The customer name
  final String? customerName;

  /// The agent customer id
  final String? agentCustomerId;

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

  /// Dial code.
  final String? dialCode;

  /// The user's image URL
  final String? imageURL;

  /// The user current status
  final UserStatus? status;

  /// A token for the network request
  final String? token;

  /// The user's e-mail address.
  final String? email;

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

  /// The date the user was created.
  final DateTime? created;

  /// The gender code.
  final CustomerGender? gender;

  /// The marital status code.
  final CustomerMaritalStatus? maritalStatus;

  /// The date of birth.
  final DateTime? dob;

  /// The mother name.
  final String? motherName;

  /// The address.
  final String? address;

  /// Whether if this user has the biometrics enabled or not.
  final bool useBiometrics;

  /// List of all visible [BankingCard]s
  final UnmodifiableListView<BankingCard> visibleCards;

  /// List of all visible [Account]s
  final UnmodifiableListView<Account> visibleAccounts;

  /// The profile image file.
  final String? image;

  /// The low balance
  final double? lowBalanceValue;

  /// List of activity types for which user receives alerts.
  final UnmodifiableListView<ActivityType> enabledAlerts;

  /// Returns the full name of the customer.
  String get fullName => [firstName, lastName]
      .where((element) => element != null && element.isNotEmpty)
      .join(' ');

  /// Creates a new [User]
  User({
    required this.id,
    this.customerId,
    this.customerName,
    this.agentCustomerId,
    this.username,
    this.imageURL,
    this.status,
    this.token,
    this.email,
    this.mobileNumber,
    this.dialCode,
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
    this.created,
    this.verifyDevice = false,
    this.branch,
    this.gender,
    this.maritalStatus,
    this.dob,
    this.motherName,
    this.address,
    this.useBiometrics = false,
    Iterable<BankingCard> visibleCards = const [],
    Iterable<Account> visibleAccounts = const [],
    Iterable<ActivityType> enabledAlerts = const <ActivityType>[],
    this.image,
  })  : favoriteOffers = UnmodifiableListView(favoriteOffers ?? []),
        roles = UnmodifiableListView(roles ?? <String>[]),
        visibleCards = UnmodifiableListView(visibleCards),
        visibleAccounts = UnmodifiableListView(visibleAccounts),
        enabledAlerts = UnmodifiableListView(enabledAlerts);

  /// Returns a copy of the user modified by the provided data.
  User copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? agentCustomerId,
    String? username,
    String? mobileNumber,
    String? dialCode,
    String? firstName,
    String? lastName,
    UserStatus? status,
    String? token,
    String? email,
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
    DateTime? created,
    bool? verifyDevice,
    String? branch,
    CustomerGender? gender,
    CustomerMaritalStatus? maritalStatus,
    DateTime? dob,
    String? motherName,
    String? address,
    bool? useBiometrics,
    Iterable<BankingCard>? visibleCards,
    Iterable<Account>? visibleAccounts,
    String? image,
    double? lowBalanceValue,
    Iterable<ActivityType>? enabledAlerts,
  }) =>
      User(
        id: id ?? this.id,
        customerId: customerId ?? this.customerId,
        customerName: customerName ?? this.customerName,
        agentCustomerId: agentCustomerId ?? this.agentCustomerId,
        username: username ?? this.username,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        dialCode: dialCode ?? this.dialCode,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        status: status ?? this.status,
        token: token ?? this.token,
        email: email ?? this.email,
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
        created: created ?? this.created,
        verifyDevice: verifyDevice ?? this.verifyDevice,
        branch: branch ?? this.branch,
        gender: gender ?? this.gender,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        dob: dob ?? this.dob,
        motherName: motherName ?? this.motherName,
        address: address ?? this.address,
        useBiometrics: useBiometrics ?? this.useBiometrics,
        visibleCards: visibleCards ?? this.visibleCards,
        visibleAccounts: visibleAccounts ?? this.visibleAccounts,
        image: image ?? this.image,
        lowBalanceValue: lowBalanceValue ?? this.lowBalanceValue,
        enabledAlerts: enabledAlerts ?? this.enabledAlerts,
      );

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        agentCustomerId,
        username,
        imageURL,
        mobileNumber,
        dialCode,
        firstName,
        lastName,
        status,
        token,
        email,
        accessPin,
        preferences,
        hasEmailAds,
        hasSmsAds,
        deviceId,
        favoriteOffers,
        roles,
        permissions,
        created,
        verifyDevice,
        created,
        branch,
        gender,
        maritalStatus,
        dob,
        motherName,
        address,
        useBiometrics,
        visibleCards,
        visibleAccounts,
        image,
        lowBalanceValue,
        enabledAlerts,
      ];
}
