import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Provides the functionality required to send an OCRA challenge and verify
/// the result.
class OcraRepository implements OcraRepositoryInterface {
  final OcraProvider _provider;

  /// Creates a new [OcraRepository].
  OcraRepository({
    required OcraProvider provider,
  }) : _provider = provider;

  /// Sends a client challenge to the API and returns the server result
  /// alongside a server challenge.
  @override
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
  @override
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
