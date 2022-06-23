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
  ///
  /// The [useOTP] parameter is used for indicating if the branch activation
  /// feature should return a second factor method when the bank has submitted
  /// the code.
  Future<BranchActivationResponse?> call({
    required String code,
    bool useOTP = true,
  }) =>
      _repository.checkBranchActivationCode(
        code: code,
        useOtp: useOTP,
      );
}
