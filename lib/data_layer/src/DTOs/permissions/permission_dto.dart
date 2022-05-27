/// DTO for a Permission definition.
class PermissionDTO {
  /// The value the permission DTO uses to denote it's a default value.
  static const String defaultValue = '*';

  /// The value the permission DTO uses to denote it's a true value.
  static const String trueValue = 'T';

  /// The permission id.
  final int? id;

  /// The module id that this permissions is linked to.
  final String? moduleId;

  /// The object id that this permissions is linked to.
  final String? moduleObjectId;

  /// The value of this permission.
  final Object? value;

  /// Creates a [PermissionDTO] object.
  PermissionDTO({
    this.id,
    this.moduleId,
    this.moduleObjectId,
    this.value,
  });

  /// Creates a [PermissionDTO] from a JSON
  factory PermissionDTO.fromJson(Map<String, dynamic> json) => PermissionDTO(
        id: json['permission_id'],
        moduleId: json['module_id'],
        moduleObjectId: json['object_id'],
        value: json['value'],
      );

  /// Creates a list of [PermissionDTO] from a JSON list
  static List<PermissionDTO>? fromJsonList(List? json) => json
      ?.map((element) => PermissionDTO.fromJson(element))
      .toList(growable: false);
}
