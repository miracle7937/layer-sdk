/// Data transfer object that represents a user role
class RoleDTO {
  /// ID of this role
  final String? roleId;

  /// Priority of this role
  final int? priority;

  /// Total number of users with this role.
  final int? numberOfUsers;

  /// Creates a new [RoleDTO] instance
  RoleDTO({
    this.roleId,
    this.priority,
    this.numberOfUsers,
  });

  /// Creates a list of [RoleDTO] from the given JSON.
  factory RoleDTO.fromJson(Map<String, dynamic> map) {
    return RoleDTO(
      roleId: map['role_id'],
      priority: map['priority']?.toInt(),
      numberOfUsers: map['number_of_users']?.toInt(),
    );
  }

  /// Creates a list of [RoleDTO]s from the given JSON list.
  static List<RoleDTO> fromJsonList(List json) =>
      json.map((role) => RoleDTO.fromJson(role)).toList();
}
