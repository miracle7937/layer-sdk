import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Defines the mapping between [OcraChallengeResultResponseDTO]
/// and [OcraChallengeResultResponse].
extension OcraChallengeResultResponseDTOMapping
    on OcraChallengeResultResponseDTO {
  /// Returns a new [OcraChallengeResultResponse] model based on the DTO.
  OcraChallengeResultResponse toOcraChallengeResultResponse() =>
      OcraChallengeResultResponse(
        token: token,
        remainingAttempts: remainingAttempts,
      );
}
