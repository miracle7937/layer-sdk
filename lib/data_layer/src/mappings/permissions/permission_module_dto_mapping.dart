import '../../../models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [PermissionModuleDTO]
extension ModuleDTOMapping on PermissionModuleDTO {
  /// Maps into a [PermissionModule]
  PermissionModule toPermissionModule() => PermissionModule(
        id: id ?? '',
        urlRegex: urlRegex ?? '',
        definitions: objects
                ?.map(
                  (e) => e.toModulePermissionDefinition(),
                )
                .toList(growable: false) ??
            <ModulePermissionDefinition>[],
      );
}
