import '../../models.dart';

/// Definition of the [PermissionRepositoryInterface].
abstract class PermissionRepositoryInterface {
  /// Lists all permission objects with its descriptions.
  Future<List<PermissionObject>> listPermissions();
}
