import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to update customer grace period
class UpdateCustomerGracePeriodUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [UpdateCustomerGracePeriodUseCase]
  UpdateCustomerGracePeriodUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  ///
  /// Used by the DBO app only.
  Future<bool> call({
    required String customerId,
    required KYCGracePeriodType type,
    int? value,
  }) =>
      _repository.updateCustomerGracePeriod(
        customerId: customerId,
        type: type,
        value: value,
      );
}
