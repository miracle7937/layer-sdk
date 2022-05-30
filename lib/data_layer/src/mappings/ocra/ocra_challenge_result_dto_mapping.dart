import '../../../models.dart';
import '../../dtos.dart';

/// Defines the mapping between [OcraChallengeResult]
/// and [OcraChallengeResultDTO].
extension OcraChallengeResultDtoMapping on OcraChallengeResult {
  /// Returns a new [OcraChallengeDTO] model based on the model.
  OcraChallengeResultDTO toDTO() => OcraChallengeResultDTO(
        result: result,
        deviceId: deviceId,
      );
}
