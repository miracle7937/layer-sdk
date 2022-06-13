import '../../models.dart';

/// The abstract repository for the device session.
abstract class DeviceSessionRepositoryInterface {
  /// Returns the [DeviceSession] for the provided parameters.
  Future<DeviceSession> getDeviceSessions({
    List<SessionType> deviceTypes = const [
      SessionType.android,
      SessionType.iOS
    ],
    SessionStatus status = SessionStatus.active,
    SessionStatus? secondStatus,
    String? sortby,
    bool? desc,
    bool forceRefresh = false,
  });

  /// Activates the device session belonging to this id
  Future<void> activateSession({
    required int deviceId,
  });

  /// Terminates the device session belonging to this id
  Future<void> terminateSession({
    required int deviceId,
  });

}
