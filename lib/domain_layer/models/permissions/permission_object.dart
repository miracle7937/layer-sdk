import 'package:equatable/equatable.dart';

/// Holds the data of a `Permission` of the server.
class PermissionObject extends Equatable {
  /// The permission id.
  final int id;

  /// The module id that this permissions is linked to.
  final String moduleId;

  /// The object id that this permissions is linked to.
  final String objectId;

  /// The description of this permission.
  final String description;

  /// The ID of the role this permission belongs to.
  final String roleId;

  /// Creates a new [PermissionObject] instance.
  PermissionObject({
    this.id = 0,
    this.moduleId = '',
    this.objectId = '',
    this.description = '',
    this.roleId = '',
  });

  /// Creates a copy of a [PermissionObject] with the provided parameters.
  PermissionObject copyWith({
    int? id,
    String? moduleId,
    String? objectId,
    String? description,
    String? roleId,
  }) {
    return PermissionObject(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      objectId: objectId ?? this.objectId,
      description: description ?? this.description,
      roleId: roleId ?? this.roleId,
    );
  }

  @override
  List<Object> get props => [
        id,
        moduleId,
        objectId,
        description,
        roleId,
      ];
}
