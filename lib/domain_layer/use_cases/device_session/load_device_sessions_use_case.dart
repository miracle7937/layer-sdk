import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading all device sessions.
class LoadDeviceSessionsUseCase {
  final DeviceSessionRepositoryInterface _repository;

  /// Creates a new [LoadSessionsUseCase] use case.
  LoadDeviceSessionsUseCase({
    required DeviceSessionRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns an device sessions response containing a list of device sessions.
  ///
  /// The [deviceTypes] value is used for getting only the device sessions that
  /// belong to those session type list.
  ///
  /// The [status] value is used for getting only the device sessions that
  /// belong to session status.
  ///
  /// The [sortby] value is used for sorting the sessions that belong to
  /// this. For ex. `last_activity`
  Future<List<DeviceSession>> call({
    List<SessionType> deviceTypes = const [
      SessionType.android,
      SessionType.iOS
    ],
    SessionStatus? status,
    SessionStatus? secondStatus,
    String? sortby,
    bool? desc,
    bool forceRefresh = false,
    required String customerId,
  }) =>
      _repository.getDeviceSessions(
        deviceTypes: deviceTypes,
        status: status,
        secondStatus: secondStatus,
        sortby: sortby,
        desc: desc,
        forceRefresh: forceRefresh,
        customerId: customerId,
      );
}
