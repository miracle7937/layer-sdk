import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the permission modules data
class PermissionModuleRepository {
  final PermissionModuleProvider _provider;

  /// Creates a new repository with the supplied [PermissionModuleProvider]
  PermissionModuleRepository({
    required PermissionModuleProvider provider,
  }) : _provider = provider;

  /// Lists all the available permission modules
  ///
  /// Console should pass `false` on [customerModules] to get the modules
  /// from the console.
  Future<List<PermissionModule>> list({
    bool customerModules = true,
    bool forceRefresh = false,
  }) async {
    final moduleDTOs = await _provider.list(
      customerModules: customerModules,
      forceRefresh: forceRefresh,
    );

    return moduleDTOs
        .map((e) => e.toPermissionModule())
        .toList(growable: false);
  }
}
