import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mapping from [SecondFactorTypeDTO]
/// to [SecondFactorType].
extension SecondFactorDTOMapping on SecondFactorTypeDTO {
  /// Returns [SecondFactorType] built from this DTO.
  SecondFactorType toSecondFactorType() {
    switch (this) {
      case SecondFactorTypeDTO.otp:
        return SecondFactorType.otp;

      case SecondFactorTypeDTO.pin:
        return SecondFactorType.pin;

      case SecondFactorTypeDTO.hardwareToken:
        return SecondFactorType.hardwareToken;

      case SecondFactorTypeDTO.ocraOrOTP:
        return SecondFactorType.ocraOrOTP;

      case SecondFactorTypeDTO.ocra:
        return SecondFactorType.ocra;

      default:
        throw MappingException(
          from: SecondFactorTypeDTO,
          to: SecondFactorType,
          value: this,
        );
    }
  }
}

/// Extension that provides mapping from [SecondFactorType]
/// to [SecondFactorTypeDTO].
extension SecondFactorMapping on SecondFactorType {
  /// Maps a [SecondFactorType] into a [SecondFactorTypeDTO].
  SecondFactorTypeDTO toSecondFactorTypeDTO() {
    switch (this) {
      case SecondFactorType.otp:
        return SecondFactorTypeDTO.otp;

      case SecondFactorType.pin:
        return SecondFactorTypeDTO.pin;

      case SecondFactorType.hardwareToken:
        return SecondFactorTypeDTO.hardwareToken;

      case SecondFactorType.ocraOrOTP:
        return SecondFactorTypeDTO.ocraOrOTP;

      case SecondFactorType.ocra:
        return SecondFactorTypeDTO.ocra;

      default:
        throw MappingException(
          from: SecondFactorType,
          to: SecondFactorTypeDTO,
          value: this,
        );
    }
  }
}
