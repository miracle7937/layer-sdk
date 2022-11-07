import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../network.dart';

/// Provides data about the Devices Sessions
class DeviceSessionProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [DeviceSessionProvider] with the supplied [NetClient].
  DeviceSessionProvider({
    required this.netClient,
  });

  /// Returns the sessions/devices for a customer.
  Future<List<DeviceSessionDTO>> getDeviceSessions({
    required String customerId,
    List<SessionType>? deviceTypes,
    SessionStatus? status,
    SessionStatus? secondStatus,
    String? sortby,
    bool? desc,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customerDevice,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
      queryParameters: {
        'customer_id': customerId,
        if (deviceTypes != null && deviceTypes.isNotEmpty)
          'device_types': deviceTypes.join(','),
        if (status != null) 'status': status,
        if (secondStatus != null) 'status2': secondStatus,
        if (sortby != null) 'sortby': sortby,
        if (desc != null) 'desc': desc,
      },
    );

    return DeviceSessionDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Terminates and wipes a device.
  ///
  /// Returns the new device data if succeeded.
  /// Returns null or throws exception on failure.
  Future<DeviceSessionDTO?> terminate({
    required String customerType,
    required String deviceId,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customerDevice,
      method: NetRequestMethods.patch,
      forceRefresh: true,
      throwAllErrors: false,
      queryParameters: {
        'customer_type': customerType,
      },
      data: [
        {
          'device_id': int.tryParse(deviceId),
          'status': 'W',
        }
      ],
    );

    final list = response.data as List;

    if (!response.success || (list.isEmpty)) return null;

    return DeviceSessionDTO.fromJson(list.first);
  }

  /// Activates a device.

  Future<void> activate({
    required String deviceId,
  }) async {
    await netClient.request(
      netClient.netEndpoints.customerDevice,
      method: NetRequestMethods.patch,
      data: [
        {
          'device_id': int.tryParse(deviceId),
        }
      ],
    );
  }
}
