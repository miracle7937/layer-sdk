import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that resends the second factor for a pay to mobile request ID.
class ResendPayToMobileSecondFactorUseCase {
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [ResendPayToMobileSecondFactorUseCase] use case.
  const ResendPayToMobileSecondFactorUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a [PayToMobile] resulting on resending the second factor for the
  /// passed [PayToMobile].
  Future<PayToMobile> call({
    required PayToMobile payToMobile,
  }) =>
      _repository.resendSecondFactor(
        payToMobile: payToMobile,
      );
}
