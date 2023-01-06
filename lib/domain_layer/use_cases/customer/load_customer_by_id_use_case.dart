import '../../abstract_repositories.dart';
import '../../models.dart';

/// UseCase that loads a customer by it's `customerId`.
class LoadCustomerByIdUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [LoadCustomerByIdUseCase] instance.
  const LoadCustomerByIdUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the customer associated with the provided `customerId`.
  Future<Customer> call({
    required String customerId,
    bool forceRefresh = false,
  }) =>
      _repository.getCustomer(
        customerId: customerId,
        forceRefresh: forceRefresh,
      );
}
