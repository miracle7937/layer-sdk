import 'package:equatable/equatable.dart';

/// Model that represents a user role.
class Role extends Equatable {
  /// ID of this role
  final String roleId;

  /// Priority of this role
  final int priority;

  /// Total number of users with this role.
  final int numberOfUsers;

  /// Creates a new [Role] instance.
  Role({
    this.roleId = '',
    this.priority = 0,
    this.numberOfUsers = 0,
  });

  /// Returns the [Role] for the provided parameters.
  Role copyWith({
    String? roleId,
    int? priority,
    int? numberOfUsers,
  }) {
    return Role(
      roleId: roleId ?? this.roleId,
      priority: priority ?? this.priority,
      numberOfUsers: numberOfUsers ?? this.numberOfUsers,
    );
  }

  @override
  List<Object> get props => [roleId, priority, numberOfUsers];
}
