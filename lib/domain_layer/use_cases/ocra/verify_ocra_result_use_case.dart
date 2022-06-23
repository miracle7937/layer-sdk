import '../../abstract_repositories.dart';
import '../../models.dart';

/// The use case responsible for verifying the OCRA server challenge result.
class VerifyOcraResultUseCase {
  final OcraRepositoryInterface _ocraRepositoryInterface;

  /// Creates new [VerifyOcraResultUseCase].
  VerifyOcraResultUseCase({
    required OcraRepositoryInterface ocraRepository,
  }) : _ocraRepositoryInterface = ocraRepository;

  /// Returns the access token in case of a successful verification, the number
  /// of remaining attempts otherwise.
  Future<OcraChallengeResultResponse> call({
    required OcraChallengeResult result,
    bool forceRefresh = false,
  }) =>
      _ocraRepositoryInterface.verifyResult(
        result: result,
        forceRefresh: forceRefresh,
      );
}
