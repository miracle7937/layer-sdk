import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// A repository responsible for fetching roles
class RolesRepository implements RolesRepositoryInterface {
  final RolesProvider _provider;

  /// Creates a new [RolesRepository] instance.
  const RolesRepository({
    required RolesProvider provider,
  }) : _provider = provider;

  /// Returns all available customer roles.
  @override
  Future<List<Role>> listCustomerRoles({
    bool forceRefresh = false,
  }) async {
    final dtos = await _provider.listCustomerRoles(
      forceRefresh: forceRefresh,
    );

    return dtos.map((e) => e.toRole()).toList();
  }

  /// Returns the list of permissions that a role has.
  @override
  Future<List<PermissionObject>> listRolePermissions({
    required String roleId,
    bool forceRefresh = false,
  }) async {
    final dtos = await _provider.listRolePermissions(
      roleId: roleId,
      forceRefresh: forceRefresh,
    );

    return dtos.map((e) => e.toPermissionObject()).toList();
  }
}
