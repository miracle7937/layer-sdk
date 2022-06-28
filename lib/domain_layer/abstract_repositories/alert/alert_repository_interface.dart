/// An abstract repository for the alert
abstract class AlertRepositoryInterface {
  /// Loads the number of unread alerts
  Future<int> getUnreadAlertsCount({bool forceRefresh = false});
}
