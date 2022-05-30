import '../../../migration/data_layer/network.dart';
import '../helpers.dart';

/// Provides data related to the alerts
class AlertProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [AlertProvider] instance
  AlertProvider(
    this.netClient,
  );

  /// Returns the number of unread alerts
  Future<int> getUnreadAlertsCount({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.unreadAlertsCount,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return JsonParser.parseInt(response.data['count']);
  }
}
