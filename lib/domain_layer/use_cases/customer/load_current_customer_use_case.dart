import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to get the current logged in customer
class LoadCurrentCustomerUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [LoadCurrentCustomerUseCase]
  LoadCurrentCustomerUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Fetches the currently logged in customer object
  Future<Customer> call() => _repository.fetchCurrentCustomer();
}
