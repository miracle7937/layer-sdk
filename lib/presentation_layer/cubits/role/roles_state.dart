import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Enum that represents all possible error statuses.
enum RolesStateError {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// Represents the [RolesCubit] state.
class RolesState extends Equatable {
  /// The list of available customer roles.
  final UnmodifiableListView<Role> roles;

  /// Whether the cubit is busy or not.
  final bool busy;

  /// The current error state.
  final RolesStateError error;

  /// Creates a new [RolesState] instance.
  RolesState({
    Iterable<Role> roles = const [],
    this.busy = false,
    this.error = RolesStateError.none,
  }) : roles = UnmodifiableListView(roles);

  /// Creates a [RolesState] copy with the provided parameters.
  RolesState copyWith({
    Iterable<Role>? roles,
    bool? busy,
    RolesStateError? error,
  }) {
    return RolesState(
      roles: roles ?? this.roles,
      busy: busy ?? this.busy,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
        roles,
        busy,
        error,
      ];
}
