import '../../../domain_layer/models/permissions/permission_object.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [PermissionDTO].
extension PermissionDTOMapping on PermissionDTO {
  /// Maps into a [PermissionObject].
  PermissionObject toPermissionObject() => PermissionObject(
        id: id ?? 0,
        moduleId: moduleId ?? '',
        objectId: moduleObjectId ?? '',
        description: description ?? '',
        roleId: roleId ?? '',
      );
}
