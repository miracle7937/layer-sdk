import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Holds the state of the [RolePermissionsCubit]
class PermissionDetailsState extends Equatable {
  /// Holds the permissions.
  final UnmodifiableListView<PermissionObject> permissions;

  /// Whether or not the cubit is busy loading.
  final bool busy;

  /// Whether or not any error has ocurred.
  final bool error;

  /// Creates a new [PermissionDetailsState] instance.
  PermissionDetailsState({
    Iterable<PermissionObject> permissionsList = const [],
    this.busy = false,
    this.error = false,
  }) : permissions = UnmodifiableListView(permissionsList);

  @override
  List<Object> get props => [
        permissions,
        busy,
        error,
      ];

  /// Creates a copy of a [PermissionDetailsState] with the provided parameters.
  PermissionDetailsState copyWith({
    List<PermissionObject>? permissions,
    bool? busy,
    bool? error,
  }) {
    return PermissionDetailsState(
      permissionsList: permissions ?? this.permissions,
      busy: busy ?? this.busy,
      error: error ?? this.error,
    );
  }
}
