import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that verifies the second factor for a pay to mobile request ID.
class VerifyPayToMobileSecondFactorUseCase {
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [VerifyPayToMobileSecondFactorUseCase] use case.
  const VerifyPayToMobileSecondFactorUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a [PayToMobile] resulting on verifying the second factor for the
  /// passed pay to mobile request ID.
  Future<PayToMobile> call({
    required String requestId,
    required String value,
    required SecondFactorType secondFactorType,
  }) =>
      _repository.verifySecondFactor(
        requestId: requestId,
        value: value,
        secondFactorType: secondFactorType,
      );
}
