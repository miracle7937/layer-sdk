import '../../../_migration/data_layer/src/mappings.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [UserDTO]
extension UserDTOMapping on UserDTO {
  /// Maps into a [User]
  User toUser({
    String? accessPin,
  }) =>
      User(
        id: id.toString(),
        username: username,
        imageURL: imageUrl,
        mobileNumber: mobileNumber,
        firstName: firstName,
        lastName: lastName,
        token: token,
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
        verifyDevice: verifyDevice ?? false,
        branch: branch,
        accessPin: accessPin,
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

      // TODO: add in the future, only if needed.
      // case 'O':
      //   return UserStatus.otp;
      //
      // case 'V':
      //   return UserStatus.verify;

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
