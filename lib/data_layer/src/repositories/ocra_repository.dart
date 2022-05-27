import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Provides the functionality required to send an OCRA challenge and verify
/// the result.
class OcraRepository {
  final OcraProvider _provider;

  /// Creates a new [OcraRepository].
  const OcraRepository(this._provider);

  /// Sends a client challenge to the API and returns the server result
  /// alongside a server challenge.
  Future<OcraChallengeResponse> challenge({
    required OcraChallenge challenge,
    bool forceRefresh = false,
  }) async {
    final dto = await _provider.challenge(
      challenge: challenge.toDTO(),
      forceRefresh: forceRefresh,
    );

    return dto.toOcraChallengeResponse();
  }

  /// Verifies the OCRA challenge result and returns a new token if the
  /// verification is successful.
  Future<OcraChallengeResultResponse> verifyResult({
    required OcraChallengeResult result,
    bool forceRefresh = false,
  }) async {
    final dto = await _provider.verifyResult(
      result: result.toDTO(),
      forceRefresh: forceRefresh,
    );

    return dto.toOcraChallengeResultResponse();
  }
}
