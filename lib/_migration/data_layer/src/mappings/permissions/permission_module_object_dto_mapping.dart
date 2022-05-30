import '../../../errors.dart';
import '../../../models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [PermissionModuleObjectDTO]
extension ModuleObjectDTOMapping on PermissionModuleObjectDTO {
  /// Maps into a [ModulePermissionDefinition]
  ModulePermissionDefinition toModulePermissionDefinition() =>
      ModulePermissionDefinition(
        id: id,
        type: type.toModulePermissionDefinitionType(),
      );
}

/// Extension that provides specialized mappings for [String] to
/// [ModulePermissionDefinitionType] related types.
extension StringToModuleObjectMapping on String {
  /// Maps into a [ModulePermissionDefinitionType]
  ModulePermissionDefinitionType toModulePermissionDefinitionType() {
    switch (toLowerCase()) {
      case 'b':
        return ModulePermissionDefinitionType.boolean;

      case 's':
        return ModulePermissionDefinitionType.string;

      default:
        throw MappingException(
          from: String,
          to: ModulePermissionDefinitionType,
          value: this,
        );
    }
  }
}
