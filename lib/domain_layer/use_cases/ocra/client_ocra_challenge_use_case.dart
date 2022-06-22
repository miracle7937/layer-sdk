import '../../abstract_repositories.dart';
import '../../models.dart';

/// The use case responsible for sending the client OCRA challenge to the API.
class ClientOcraChallengeUseCase {
  final OcraRepositoryInterface _ocraRepository;

  /// Creates new [ClientOcraChallengeUseCase].
  ClientOcraChallengeUseCase({
    required OcraRepositoryInterface ocraRepository,
  }) : _ocraRepository = ocraRepository;

  /// Returns the server response to the client challenge alongside the server
  /// challenge.
  Future<OcraChallengeResponse> call({
    required OcraChallenge challenge,
    bool forceRefresh = false,
  }) =>
      _ocraRepository.challenge(
        challenge: challenge,
        forceRefresh: forceRefresh,
      );
}
