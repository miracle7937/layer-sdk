import '../../../layer_sdk.dart';

/// Handles all the alerts data
class AlertRepository implements AlertRepositoryInterface {
  final AlertProvider _provider;

  /// Creates a new [AlertRepository] instance
  AlertRepository(this._provider);

  /// Retrieves the number of unread alerts
  @override
  Future<int> getUnreadAlertsCount({
    bool forceRefresh = false,
  }) async {
    final count = await _provider.getUnreadAlertsCount(
      forceRefresh: forceRefresh,
    );

    return count;
  }
}
