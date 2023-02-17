
import 'package:permission_handler/permission_handler.dart';

/// A wrapper for permission handler method.
///
/// It is used as a easily mockable testing utility, since mocking a permission
/// would require us to use `MethodChannel().setMockMethodCallHandler`,
/// because PermissionHandler uses method channel in extension methods
/// that can't be mocked with Mockito.
class DevicePermissionsWrapper {
  /// Returns the status of provided permission.
  Future<PermissionStatus> status(Permission permission) => permission.status;

  /// Requests the provided permission and returns its status.
  Future<PermissionStatus> request(Permission permission) =>
      permission.request();
}
