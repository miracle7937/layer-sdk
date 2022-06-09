import '../../models/role/role.dart';

/// An abstract repository for the roles.
abstract class RolesRepositoryInterface {
  /// Returns all available customer roles.
  Future<List<Role>> listCustomerRoles({bool forceRefresh = false});
}
