import '../../network.dart';
import '../dtos.dart';

/// Provides data about the Devices Sessions
class DeviceSessionProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [DeviceSessionProvider] with the supplied [NetClient].
  DeviceSessionProvider({
    required this.netClient,
  });

  /// Returns the sessions/devices for a customer.
  Future<List<DeviceSessionDTO>> list({
    required String customerId,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customerDevice,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
      queryParameters: {
        'customer_id': customerId,
      },
    );

    return DeviceSessionDTO.fromJsonList(response.data);
  }

  /// Wipes a device.
  ///
  /// Returns the new device data if succeeded.
  /// Returns null or throws exception on failure.
  Future<DeviceSessionDTO?> wipe({
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
}
