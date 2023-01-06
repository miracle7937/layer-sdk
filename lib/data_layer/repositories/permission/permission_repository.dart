import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Repository that provides permissions data.
class PermissionRepository implements PermissionRepositoryInterface {
  final PermissionProvider _provider;

  /// Creates a new [PermissionRepository] instance.
  PermissionRepository({
    required PermissionProvider provider,
  }) : _provider = provider;

  /// Returns the list of permission objects with its descriptions.
  @override
  Future<List<PermissionObject>> listPermissions() async {
    final dtos = await _provider.listPermissions();

    return dtos.map((e) => e.toPermissionObject()).toList();
  }
}
