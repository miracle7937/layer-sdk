import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to load the [User]
class LoadUsersByCustomerIdUseCase {
  final UserRepositoryInterface _repository;

  /// Creates a new [LoadUsersByCustomerIdUseCase] instance
  LoadUsersByCustomerIdUseCase({
    required UserRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load the [User] by `customerId`
  Future<List<User>> call({
    required String customerID,
    bool forceRefresh = false,
    String? name,
    UserSort sortBy = UserSort.registered,
    bool descendingOrder = true,
    int limit = 50,
    int offset = 0,
  }) =>
      _repository.getUsers(
        customerID: customerID,
        descendingOrder: descendingOrder,
        forceRefresh: forceRefresh,
        limit: limit,
        name: name,
        offset: offset,
        sortBy: sortBy,
      );
}
