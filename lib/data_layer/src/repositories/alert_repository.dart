import '../../providers.dart';

/// Handles all the alerts data
class AlertRepository {
  final AlertProvider _provider;

  /// Creates a new [AlertRepository] instance
  AlertRepository(this._provider);

  /// Retrieves the number of unread alerts
  Future<int> getUnreadAlertsCount({
    bool forceRefresh = false,
  }) async {
    final count = await _provider.getUnreadAlertsCount(
      forceRefresh: forceRefresh,
    );

    return count;
  }
}
