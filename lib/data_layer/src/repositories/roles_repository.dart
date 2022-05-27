import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// A repository responsible for fetching roles
class RolesRepository {
  final RolesProvider _provider;

  /// Creates a new [RolesRepository] instance.
  const RolesRepository({
    required RolesProvider provider,
  }) : _provider = provider;

  /// Returns all available customer roles.
  Future<List<Role>> listCustomerRoles({
    bool forceRefresh = false,
  }) async {
    final dtos = await _provider.listCustomerRoles(
      forceRefresh: forceRefresh,
    );

    return dtos.map((e) => e.toRole()).toList();
  }
}
