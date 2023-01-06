import '../../models.dart';

/// An abstract repository for the roles.
abstract class RolesRepositoryInterface {
  /// Returns all available customer roles.
  Future<List<Role>> listCustomerRoles({bool forceRefresh = false});

  /// Returns all permissions of the provided `roleId`
  Future<List<PermissionObject>> listRolePermissions({
    required String roleId,
    bool forceRefresh = false,
  });
}
