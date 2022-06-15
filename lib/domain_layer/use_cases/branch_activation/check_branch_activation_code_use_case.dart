import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for checking the branch activation code.
class CheckBranchActivationCodeUseCase {
  final BranchActivationRepositoryInterface _repository;

  /// Creates a new [CheckBranchActivationCodeUseCase].
  const CheckBranchActivationCodeUseCase({
    required BranchActivationRepositoryInterface repository,
  }) : _repository = repository;

  /// Checks the passed branch activation code.
  Future<BranchActivationResponse?> call({
    required String code,
    bool useOTP = true,
  }) =>
      _repository.checkBranchActivationCode(
        code: code,
        useOtp: useOTP,
      );
}
