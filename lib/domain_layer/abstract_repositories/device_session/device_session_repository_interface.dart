import '../../models.dart';

/// The abstract repository for the device session.
abstract class DeviceSessionRepositoryInterface {
  /// Returns the [DeviceSession] for the provided parameters.
  Future<List<DeviceSession>> getDeviceSessions({
    List<SessionType> deviceTypes = const [
      SessionType.android,
      SessionType.iOS
    ],
    SessionStatus status = SessionStatus.active,
    SessionStatus? secondStatus,
    required String customerId,
    String? sortby,
    bool? desc,
    bool forceRefresh = false,
  });

  /// Activates the device session belonging to this id
  Future<void> activateSession({
    required String deviceId,
  });

  /// Terminates the device session belonging to this id
  Future<void> terminateSession({
    required String deviceId,
    required CustomerType customerType,
  });
}
