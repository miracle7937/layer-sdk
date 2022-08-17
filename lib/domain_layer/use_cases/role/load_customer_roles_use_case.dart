import '../../abstract_repositories.dart';
import '../../models/role/role.dart';

/// Use case that loads all customer roles
class LoadCustomerRolesUseCase {
  final RolesRepositoryInterface _repository;

  /// Creates a new [LoadCustomerRolesUseCase] use case
  LoadCustomerRolesUseCase({
    required RolesRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable methot to retrives all customer roles list
  Future<List<Role>> call({
    bool forceRefresh = false,
  }) =>
      _repository.listCustomerRoles(
        forceRefresh: forceRefresh,
      );
}
