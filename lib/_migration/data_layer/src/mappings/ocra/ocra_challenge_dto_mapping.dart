import '../../../models.dart';
import '../../dtos.dart';

/// Defines the mapping between [OcraChallenge] and [OcraChallengeDTO].
extension OcraChallengeDtoMapping on OcraChallenge {
  /// Returns a new [OcraChallengeDTO] model based on the model.
  OcraChallengeDTO toDTO() => OcraChallengeDTO(
        deviceId: deviceId,
        challenge: challenge,
      );
}
