/// DTO for a permission module.
class PermissionModuleDTO {
  /// The permission module id.
  final String? id;

  /// The regular expression to use for selecting the URL.
  final String? urlRegex;

  /// A list of [PermissionModuleObjectDTO] that define this module.
  final List<PermissionModuleObjectDTO>? objects;

  /// Creates a new [PermissionModuleDTO].
  PermissionModuleDTO({
    this.id,
    this.urlRegex,
    this.objects,
  });

  /// Creates a [PermissionModuleDTO] from a JSON
  factory PermissionModuleDTO.fromJson(Map<String, dynamic> json) =>
      PermissionModuleDTO(
        id: json['module_id'],
        urlRegex: json['url_re'],
        objects: PermissionModuleObjectDTO.fromJsonList(json['object']),
      );

  /// Creates a list of [PermissionModuleDTO] from a JSON list
  static List<PermissionModuleDTO> fromJsonList(List json) => json
      .map((element) => PermissionModuleDTO.fromJson(element))
      .toList(growable: false);
}

/// The DTO for a permission module object.
class PermissionModuleObjectDTO {
  /// The object id.
  final String id;

  /// The type of this permission module object.
  final String type;

  /// Creates a new [PermissionModuleObjectDTO].
  PermissionModuleObjectDTO({
    required this.id,
    required this.type,
  });

  /// Creates a [PermissionModuleObjectDTO] from a JSON
  factory PermissionModuleObjectDTO.fromJson(Map<String, dynamic> json) =>
      PermissionModuleObjectDTO(
        id: json['object_id'],
        type: json['type'],
      );

  /// Creates a list of [PermissionModuleObjectDTO] from a JSON list
  static List<PermissionModuleObjectDTO>? fromJsonList(List? json) => json
      ?.map((element) => PermissionModuleObjectDTO.fromJson(element))
      .toList(growable: false);
}
