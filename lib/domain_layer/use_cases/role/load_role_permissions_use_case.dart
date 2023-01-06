import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that loads all permissions of a [Role].
class LoadRolePermissionsUseCase {
  final RolesRepositoryInterface _repository;

  /// Creates a new [LoadRolePermissionsUseCase] instance.
  LoadRolePermissionsUseCase({
    required RolesRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns all permissions of the provided `roleId`
  Future<List<PermissionObject>> call({
    required String roleId,
    bool forceRefresh = false,
  }) =>
      _repository.listRolePermissions(
        roleId: roleId,
        forceRefresh: forceRefresh,
      );
}
