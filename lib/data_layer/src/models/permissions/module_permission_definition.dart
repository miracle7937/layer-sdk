import 'package:equatable/equatable.dart';

/// The available types for a [ModulePermissionDefinition].
enum ModulePermissionDefinitionType {
  /// Boolean.
  boolean,

  /// String.
  string,
}

/// Holds the data for a permission of a [PermissionModule].
class ModulePermissionDefinition extends Equatable {
  /// The object id.
  final String id;

  /// The type of this permission definition.
  final ModulePermissionDefinitionType type;

  /// Creates a new [ModulePermissionDefinition].
  ModulePermissionDefinition({
    required this.id,
    required this.type,
  });

  @override
  List<Object> get props => [
        id,
        type,
      ];

  /// Returns a copy of this object with select different values.
  ModulePermissionDefinition copyWith({
    String? id,
    ModulePermissionDefinitionType? type,
  }) =>
      ModulePermissionDefinition(
        id: id ?? this.id,
        type: type ?? this.type,
      );
}
