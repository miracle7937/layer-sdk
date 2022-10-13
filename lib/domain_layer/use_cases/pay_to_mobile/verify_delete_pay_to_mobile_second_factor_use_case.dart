import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that verifies the second factor for deleting a pay to mobile
/// request ID.
class VerifyDeletePayToMobileSecondFactorUseCase {
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [VerifyDeletePayToMobileSecondFactorUseCase] use case.
  const VerifyDeletePayToMobileSecondFactorUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Verifies the second factor for deleting the passed pay to mobile
  /// request ID.
  Future<void> call({
    required String requestId,
    required String value,
    required SecondFactorType secondFactorType,
  }) =>
      _repository.verifySecondFactorForDeleting(
        requestId: requestId,
        value: value,
        secondFactorType: secondFactorType,
      );
}
