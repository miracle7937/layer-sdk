import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mappings for [VerifyPinResponseDTO]
extension VerifyPinResponseDTOMapping on VerifyPinResponseDTO {
  /// Maps into a [VerifyPinResponse]
  VerifyPinResponse toVerifyPinResponse() => VerifyPinResponse(
        isVerified: isVerified ?? false,
        remainingAttempts: remainingAttempts,
      );
}
