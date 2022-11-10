import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../cubits.dart';

/// A cubit that handles requesting device permissions.
class DevicePermissionsCubit extends Cubit<DevicePermissionsState> {
  final DevicePermissionsWrapper _wrapper;

  /// Creates [DevicePermissionsCubit].
  DevicePermissionsCubit({
    required DevicePermissionsWrapper wrapper,
  })  : _wrapper = wrapper,
        super(DevicePermissionsState());

  /// Returns the updated status of the permission.
  ///
  /// Requests the permission only if needed.
  /// The [openSettings] callback should open the device permission settings
  /// if the user chooses to do so. After he returns from the settings
  /// the permission status is checked again.
  Future<PermissionStatus> requestPermission({
    required AsyncCallback openSettings,
    required Permission permission,
  }) async {
    var status = await _wrapper.status(permission);
    if (status == PermissionStatus.granted) {
      emit(state.copyWith(
        permission: permission,
        status: status,
      ));
      return status;
    }

    if (status == PermissionStatus.permanentlyDenied) {
      await openSettings();
      status = await _wrapper.status(permission);
    } else {
      status = await _wrapper.request(permission);
      if (status == PermissionStatus.permanentlyDenied) {
        await openSettings();
        status = await _wrapper.status(permission);
      }
    }

    emit(state.copyWith(
      permission: permission,
      status: status,
    ));

    return status;
  }

  /// Returns the current status for the passed permission.
  ///
  /// Used when the request is not needed.
  Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    final status = await _wrapper.status(permission);

    emit(state.copyWith(
      permission: permission,
      status: status,
    ));

    return status;
  }
}
