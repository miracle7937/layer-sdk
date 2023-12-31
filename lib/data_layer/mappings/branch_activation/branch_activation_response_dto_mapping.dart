import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mapping from [BranchActivationResponseDTO]
/// to [BranchActivationResponse].
extension BranchActivationResponseResponseDTOMapping
    on BranchActivationResponseDTO {
  /// Returns [BranchActivationResponse] built from this DTO.
  BranchActivationResponse toBranchActivationResponse() =>
      BranchActivationResponse(
        secondFactorVerification: secondFactor != null
            ? SecondFactorVerification(
                id: otpId,
                type: secondFactor!.toSecondFactorType(),
              )
            : null,
        token: token,
        deviceId: deviceId,
        ocraSecret: ocraSecret,
      );
}
