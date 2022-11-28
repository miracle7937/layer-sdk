import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that resends the second factor for deleting a a pay to mobile
/// request ID.
class ResendDeletePayToMobileSecondFactorUseCase {
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [ResendDeletePayToMobileSecondFactorUseCase] use case.
  const ResendDeletePayToMobileSecondFactorUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a [PayToMobile] resulting on resending the second factor for
  /// deleting the passed [NewPayToMobile].
  Future<PayToMobile> call({
    required String requestId,
  }) =>
      _repository.resendSecondFactorForDeleting(
        requestId: requestId,
      );
}
