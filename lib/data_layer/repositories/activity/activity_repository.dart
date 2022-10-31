import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the activities data
class ActivityRepository implements ActivityRepositoryInterface {
  final ActivityProvider _provider;

  /// Creates a new [ActivityRepository] instance
  ActivityRepository({
    required ActivityProvider provider,
  }) : _provider = provider;

  DPAMappingCustomData get _createCustomData => DPAMappingCustomData(
        token: _provider.netClient.currentToken() ?? '',
        fileBaseURL: _provider.netClient.netEndpoints.infobankingLink,
      );

  /// Load all the activities
  @override
  Future<List<Activity>> list({
    DateTime? fromTS,
    DateTime? toTS,
    int? limit,
    int? offset,
    int? alertID,
    int? transferId,
    int? paymentId,
    String? typeItemID,
    String? searchStr,
    String? itemType,
    String? sortBy,
    bool? requestAlert,
    bool? hideRequests,
    bool includeDetails = true,
    bool removeDuplicates = true,
    bool searchRequestsAndTransfer = true,
    bool searchAlerts = true,
    bool searchUserTasks = true,
    bool? itemIsNull = false,
    ActivityType? type,
    List<ActivityType>? types,
    List<TransferType>? transferTypes,
    List<ActivityTag>? activityTags,
  }) async {
    final activitiesDTO = await _provider.list(
      fromTS: fromTS,
      toTS: toTS,
      limit: limit,
      offset: offset,
      alertID: alertID,
      transferId: transferId,
      paymentId: paymentId,
      typeItemID: typeItemID,
      searchStr: searchStr,
      itemType: itemType,
      sortBy: sortBy,
      requestAlert: requestAlert,
      hideRequests: hideRequests,
      includeDetails: includeDetails,
      removeDuplicates: removeDuplicates,
      searchRequestsAndTransfer: searchRequestsAndTransfer,
      searchAlerts: searchAlerts,
      searchUserTasks: searchUserTasks,
      itemIsNull: itemIsNull,
      type: type,
      types: types,
      transferTypes: transferTypes,
      activityTags: activityTags,
    );

    return activitiesDTO.map((e) => e.toActivity(_createCustomData)).toList();
  }

  /// Delete an [Activity] by `activityId`
  @override
  Future<void> delete(String activityId) => _provider.delete(activityId);

  /// Cancel an [Activity] by `id`
  @override
  Future<void> cancel(String id, {String? otpValue}) {
    final result = _provider.cancel(id, otpValue: otpValue);

    return result;
  }

  /// Cancel the recurring transfer [Activity] by `id`
  @override
  Future<void> cancelRecurringTransfer(String id, {String? otpValue}) {
    final result = _provider.cancelRecurringTransfer(id, otpValue: otpValue);

    return result;
  }

  /// Read the current [Alert] by respective `id`
  @override
  Future<void> markAlertAsRead(int id) {
    final result = _provider.markAlertAsRead(id);

    return result;
  }

  /// Read the current [Request] by respective `id`
  @override
  Future<void> markRequestAsRead(String id) {
    final result = _provider.markRequestAsRead(id);

    return result;
  }

  /// Delete the current [Alert] by respective `id`
  @override
  Future<void> deleteAlert(int id) {
    final result = _provider.deleteAlert(id);

    return result;
  }

  /// Delete the current [Request] by respective `id`
  @override
  Future<void> deleteRequest(String id) {
    final result = _provider.deleteRequest(id);

    return result;
  }

  /// Read all the [Alert]'s
  @override
  Future<void> markAllAlertsAsRead() {
    final result = _provider.markAllAlertsAsRead();

    return result;
  }

  /// Read all the [Request]'s
  @override
  Future<void> markAllRequestsAsRead() {
    final result = _provider.markAllRequestsAsRead();

    return result;
  }

  /// Delete all the [Alert]'s
  @override
  Future<void> deleteAllAlerts() {
    final result = _provider.deleteAllAlerts();

    return result;
  }

  /// Delete all the [Request]'s
  @override
  Future<void> deleteAllRequests() {
    final result = _provider.deleteAllRequests();

    return result;
  }

  /// Retrive the alert by the activity query from push notification
  @override
  Future<Activity> getAlertByActivityQuery(
    Map<String, dynamic> query, {
    required bool includeDetails,
  }) async {
    final result = await _provider.getAlertByActivityQuery(
      query,
      includeDetails: includeDetails,
    );

    return result.toActivity(_createCustomData);
  }
}
