import '../../dtos/payment/service_dto.dart';
import '../../network/net_client.dart';
import '../../network/net_request_methods.dart';

/// Provides data about services
class ServiceProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [ServiceProvider] with the supplied [NetClient].
  ServiceProvider({
    required this.netClient,
  });

  /// Returns the services.
  ///
  /// * Use `billerId` to filter services by their biller
  /// * Use `sortByName` to sort the services by their name
  Future<List<ServiceDTO>> list({
    String? billerId,
    bool sortByName = false,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.service,
      method: NetRequestMethods.get,
      queryParameters: {
        if (billerId?.isNotEmpty ?? false) 'biller_id': billerId,
        if (sortByName) 'sortby': 'name',
      },
      forceRefresh: forceRefresh,
    );

    return ServiceDTO.fromJsonList(
      List.from(response.data),
    );
  }
}
