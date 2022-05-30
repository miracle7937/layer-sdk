import '../../errors.dart';
import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mapping from [SecondFactorDTO]
/// to [SecondFactorType].
extension SecondFactorMapping on SecondFactorDTO {
  /// Returns [SecondFactorType] built from this DTO.
  SecondFactorType toSecondFactorType() {
    switch (this) {
      case SecondFactorDTO.otp:
        return SecondFactorType.otp;

      case SecondFactorDTO.pin:
        return SecondFactorType.pin;

      case SecondFactorDTO.hardwareToken:
        return SecondFactorType.hardwareToken;

      default:
        throw MappingException(
          from: SecondFactorVerification,
          to: SecondFactorType,
          value: this,
        );
    }
  }
}
