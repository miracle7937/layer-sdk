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
}
