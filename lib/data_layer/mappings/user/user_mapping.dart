import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../helpers.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [User]
extension UserMapping on User {
  /// Maps into a [UserDTO]
  UserDTO toUserDTO() => UserDTO(
        id: int.tryParse(id),
        customerId: customerId,
        agentCustomerId: agentCustomerId,
        username: username,
        imageUrl: imageURL,
        mobileNumber: mobileNumber,
        firstName: firstName,
        lastName: lastName,
        token: token,
        email: email,
        hasEmailAds: hasEmailAds,
        hasSmsAds: hasSmsAds,
        favoriteOffers: favoriteOffers,
        role: roles,
        deviceId: deviceId,
        isUSSDActive: isUSSDActive,
        created: created,
        verifyDevice: verifyDevice,
        gender: gender?.toJSONString(),
        maritalStatus: maritalStatus?.toJSONString(),
        dob: dob != null
            ? JsonParser.parseDateWithPattern(
                dob!,
                'yyyy-MM-dd',
              )
            : null,
        managingBranch: branch,
        motherName: motherName,
        address1: address,
        visibleAccounts: visibleAccounts.map(
          (account) => account.toAccountDTO(),
        ),
        visibleCards: visibleCards.map(
          (card) => card.toCardDTO(),
        ),
        image: image,
      );
}
