import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [RoleDTO].
extension RoleDTOMapping on RoleDTO {
  /// Maps into [Role].
  Role toRole() => Role(
        roleId: roleId ?? '',
        numberOfUsers: numberOfUsers ?? 0,
        priority: priority ?? 0,
      );
}
