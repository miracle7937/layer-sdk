import '../../../errors.dart';
import '../../../models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mapping from [RegistrationResponseDTO]
/// to [RegistrationResponse].
extension RegistrationResponseDTOMapping on RegistrationResponseDTO {
  /// Returns [RegistrationResponse] built from this DTO.
  RegistrationResponse toRegistrationResponse() {
    if (customerId == null) {
      throw MappingException(
        from: RegistrationResponseDTO,
        to: RegistrationResponse,
        value: this,
        details: 'One of the required parameters is null',
      );
    }
    return RegistrationResponse(
      secondFactorVerification: secondFactor != null
          ? SecondFactorVerification(
              id: otpId,
              type: secondFactor!.toSecondFactorType(),
            )
          : null,
      user: User(
        id: customerId!,
        token: token,
        firstName: firstName,
        lastName: lastName,
        mobileNumber: maskedMobileNumber,
        status: UserStatus.active,
        deviceId: deviceId,
      ),
      ocraSecret: ocraSecret,
    );
  }
}
