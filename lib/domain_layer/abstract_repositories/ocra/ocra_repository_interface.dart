import '../../models.dart';

/// Provides the functionality required to send an OCRA challenge and verify
/// the result.
abstract class OcraRepositoryInterface {
  /// Sends a client challenge to the API and returns the server result
  /// alongside a server challenge.
  Future<OcraChallengeResponse> challenge({
    required OcraChallenge challenge,
    bool forceRefresh = false,
  });

  /// Verifies the OCRA challenge result and returns a new token if the
  /// verification is successful.
  Future<OcraChallengeResultResponse> verifyResult({
    required OcraChallengeResult result,
    bool forceRefresh = false,
  });
}
