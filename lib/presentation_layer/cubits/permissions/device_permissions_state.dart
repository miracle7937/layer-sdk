import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

/// A state representing the status of device permissions;
class DevicePermissionsState extends Equatable {
  /// The current statuses of the permissions.
  ///
  /// This map is lazy, the statuses will be updated only after calling
  /// [requestPermission] method on the [DevicePermissionsCubit].
  final UnmodifiableMapView<Permission, PermissionStatus> permissionStatus;

  /// Creates [DevicePermissionsState].
  DevicePermissionsState({
    Map<Permission, PermissionStatus>? permissionStatus,
  }) : permissionStatus = UnmodifiableMapView(permissionStatus ?? {});

  /// Creates a copy of this state with modified status
  /// of the provided permission.
  DevicePermissionsState copyWith({
    required Permission permission,
    required PermissionStatus status,
  }) {
    final newMap = Map<Permission, PermissionStatus>.from(permissionStatus);
    newMap[permission] = status;
    return DevicePermissionsState(permissionStatus: newMap);
  }

  @override
  List<Object?> get props => [
        permissionStatus,
      ];
}
