import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for deleting a pay to mobile transaction.
class DeletePayToMobileUseCase {
  /// The respository.
  final PayToMobileRepositoryInterface _repository;

  /// Creates a new [DeletePayToMobileUseCase].
  const DeletePayToMobileUseCase({
    required PayToMobileRepositoryInterface repository,
  }) : _repository = repository;

  /// Deletes the pay to mobile related to the passed request ID and returns
  /// the deleted [PayToMobile] object.
  ///
  /// If the request succeded (no second factor was returned) `null` will be
  /// returned.
  Future<PayToMobile?> call({
    required String requestId,
  }) =>
      _repository.delete(
        requestId: requestId,
      );
}
