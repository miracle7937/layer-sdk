import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to load the [User]
class LoadUserByCustomerIdUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [LoadUserByCustomerIdUseCase] instance
  LoadUserByCustomerIdUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load the [User] by `customerId`
  Future<User> call({
    String? customerID,
    bool forceRefresh = false,
  }) =>
      _repository.getUser(
        customerID: customerID,
        forceRefresh: forceRefresh,
      );
}
