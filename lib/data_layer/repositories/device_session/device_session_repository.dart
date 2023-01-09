import '../../../../data_layer/network.dart';
import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the device sessions data
class DeviceSessionRepository implements DeviceSessionRepositoryInterface {
  final DeviceSessionProvider _provider;

  /// Creates a new repository with the supplied [DeviceSessionProvider]
  DeviceSessionRepository(DeviceSessionProvider provider)
      : _provider = provider;

  /// Lists all the device sessions of a customer.
  @override
  Future<List<DeviceSession>> getDeviceSessions({
    List<SessionType> deviceTypes = const [
      SessionType.android,
      SessionType.iOS
    ],
    SessionStatus? status,
    SessionStatus? secondStatus,
    String? sortby,
    required String customerId,
    bool? desc,
    bool forceRefresh = false,
  }) async {
    final deviceDTOs = await _provider.getDeviceSessions(
      forceRefresh: forceRefresh,
      customerId: customerId,
      deviceTypes: deviceTypes,
      status: status,
      secondStatus: secondStatus,
      sortby: sortby,
      desc: desc,
    );

    return deviceDTOs
        .map((session) => session.toDeviceSession())
        .toList(growable: false);
  }

  /// Terminates a session using the customerType and the deviceId.
  ///
  /// Throws exception if failed to terminate the session.
  @override
  Future<DeviceSession> terminateSession({
    required String deviceId,
    required CustomerType customerType,
  }) async {
    final deviceDTO = await _provider.terminate(
      customerType: customerType.toJSONString(),
      deviceId: deviceId,
    );

    if (deviceDTO == null) throw NetException(details: 'No result');

    return deviceDTO.toDeviceSession();
  }

  /// Activates a session using the deviceId.
  @override
  Future<void> activateSession({
    required String deviceId,
  }) async {
    await _provider.activate(
      deviceId: deviceId,
    );
  }
}
