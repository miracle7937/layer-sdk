import '../../../_migration/data_layer/src/mappings.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../helpers/json_parser.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [UserDTO]
extension UserDTOMapping on UserDTO {
  /// Maps into a [User]
  User toUser({
    String? accessPin,
  }) =>
      User(
        id: id.toString(),
        customerId: customerId,
        agentCustomerId: agentCustomerId,
        username: username,
        imageURL: imageUrl,
        mobileNumber: mobileNumber,
        firstName: firstName,
        lastName: lastName,
        token: token,
        email: email,
        status:
            code?.toUserStatus() ?? status?.toUserStatus() ?? UserStatus.active,
        preferences: userPreferences?.toPreference() ?? const Preferences(),
        hasEmailAds: hasEmailAds ?? false,
        hasSmsAds: hasSmsAds ?? false,
        favoriteOffers: favoriteOffers,
        roles: role,
        deviceId: deviceId,
        permissions:
            permissions?.toUserPermissions() ?? const UserPermissions(),
        isUSSDActive: isUSSDActive ?? false,
        created: created,
        verifyDevice: verifyDevice ?? false,
        branch: branch ?? managingBranch,
        address: address1,
        dob: JsonParser.parseStringDate(dob),
        gender: gender?.toCustomerGender(),
        maritalStatus: maritalStatus?.toCustomerMaritalStatus(),
        motherName: motherName,
        accessPin: accessPin,
        enabledAlerts: enabledAlerts
                ?.map(
                  (activityTypeDTO) => activityTypeDTO.toType(),
                )
                .toList() ??
            [],
      );
}

extension on LoginCodeDTO {
  UserStatus? toUserStatus() {
    if (this == LoginCodeDTO.passwordExpired) return UserStatus.expired;

    if (this == LoginCodeDTO.loginStatusSuspended) return UserStatus.suspended;

    if (this == LoginCodeDTO.forceChangePassword) {
      return UserStatus.changePassword;
    }

    if (this == LoginCodeDTO.calendarClosed) {
      return UserStatus.calendarClosed;
    }

    return null;
  }
}

extension on String {
  UserStatus? toUserStatus() {
    switch (this) {
      case 'A':
        return UserStatus.active;

      case 'I':
        return UserStatus.inactive;

      case 'S':
        return UserStatus.suspended;

      case 'P':
        return UserStatus.changePassword;

      case 'U':
        return UserStatus.pending;

      case 'B':
        return UserStatus.blocked;

      case 'X':
        return UserStatus.locked;

      default:
        return null;
    }
  }
}

/// Extension that provides mappings for [UserSort]
extension UserSortMapping on UserSort {
  /// Maps into a [String].
  String toFieldName() {
    switch (this) {
      case UserSort.id:
        return 'a_user_id';
      case UserSort.username:
        return 'username';
      case UserSort.agentCustomerId:
        return 'agent_customer_id';
      case UserSort.name:
        return 'full_name';
      case UserSort.email:
        return 'email';
      case UserSort.mobile:
        return 'mobile_number';
      case UserSort.status:
        return 'status';
      case UserSort.role:
        return 'role_id';
      case UserSort.registered:
        return 'ts_created';
    }
  }
}
