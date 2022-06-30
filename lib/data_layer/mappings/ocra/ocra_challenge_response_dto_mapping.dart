import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors/mapping_error.dart';

/// Defines the mapping between [OcraChallengeResponseDTO] and
/// [OcraChallengeResponse].
extension OcraChallengeResponseDTOMapping on OcraChallengeResponseDTO {
  /// Returns a new [OcraChallengeResponse] model based on the DTO.
  OcraChallengeResponse toOcraChallengeResponse() {
    if (serverResponse == null || serverChallenge == null) {
      throw MappingException(
        from: OcraChallengeResponseDTO,
        to: OcraChallengeResponse,
        value: this,
      );
    }
    return OcraChallengeResponse(
      serverResponse: serverResponse!,
      serverChallenge: serverChallenge!,
    );
  }
}
