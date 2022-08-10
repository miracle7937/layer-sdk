import '../../abstract_repositories.dart';
import '../../models.dart';

/// UseCase that loads the [CustomerLimit] of a [Customer].
class LoadCustomerLimitsUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [LoadCustomerLimitsUseCase] instance.
  LoadCustomerLimitsUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads the limits of the customer.
  ///
  /// Returns `null` if the customer has no limits set.
  Future<CustomerLimit?> call() => _repository.getCustomerLimits();
}
