import '../../abstract_repositories.dart';
import '../../models.dart';
import '../../use_cases.dart';

/// The use case to filter the activities transfer types.
class FilterTransferActivityTypesUseCase extends LoadActivitiesUseCase {
  /// Creates a new [FilterTransferActivityTypesUseCase]
  FilterTransferActivityTypesUseCase({
    required ActivityRepositoryInterface repository,
  }) : super(repository: repository);

  /// Callable method to load all activities and filter the transfers types
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  @override
  Future<List<Activity>> call({
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
    bool forceRefresh = false,
  }) async {
    final result = await super.call(
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
      transferTypes: transferTypes,
      type: type,
      types: types,
      activityTags: activityTags,
      forceRefresh: forceRefresh,
    );

    final newAlerts = List<Activity>.from(result);

    newAlerts.removeWhere((element) {
      if (element.status != 'F') {
        if (element.type == ActivityType.transfer ||
            element.type == ActivityType.scheduledTransfer ||
            element.type == ActivityType.recurringTransfer) {
          return true;
        }
      }
      return false;
    });

    return newAlerts;
  }
}
