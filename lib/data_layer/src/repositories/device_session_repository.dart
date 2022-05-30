import '../../models.dart';
import '../../network.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the device sessions data
class DeviceSessionRepository {
  final DeviceSessionProvider _provider;

  /// Creates a new repository with the supplied [DeviceSessionProvider]
  DeviceSessionRepository(DeviceSessionProvider provider)
      : _provider = provider;

  /// Lists all the device sessions of a customer.
  Future<List<DeviceSession>> list({
    required String customerId,
    bool forceRefresh = false,
  }) async {
    final deviceDTOs = await _provider.list(
      customerId: customerId,
      forceRefresh: forceRefresh,
    );

    return deviceDTOs.map((e) => e.toDeviceSession()).toList(growable: false);
  }

  /// Terminates a session using the customerType and the deviceId.
  ///
  /// Throws exception if failed to terminate the session.
  Future<DeviceSession> terminateSession({
    required CustomerType customerType,
    required String deviceId,
  }) async {
    final deviceDTO = await _provider.wipe(
      customerType: customerType.toJSONString(),
      deviceId: deviceId,
    );

    if (deviceDTO == null) throw NetException(details: 'No result');

    return deviceDTO.toDeviceSession();
  }
}
