import '../../abstract_repositories.dart';

/// Use case for resending a withdrawal code for a pay to mobile transaction.
class ResendWithdrawalCodeForPayToMobileUseCase {
  /// The respository.
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [ResendWithdrawalCodeForPayToMobileUseCase].
  const ResendWithdrawalCodeForPayToMobileUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Resends the widthdrawal code for the passed pay to mobile request ID.
  Future<void> call({
    required String requestId,
  }) =>
      _repository.resendWithdrawalCode(
        requestId: requestId,
      );
}
