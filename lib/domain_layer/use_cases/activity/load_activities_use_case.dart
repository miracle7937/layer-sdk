import '../../abstract_repositories.dart';
import '../../models.dart';

/// The use case to load all activities
class LoadActivitiesUseCase {
  final ActivityRepositoryInterface _repository;

  /// Creates a new [LoadActivitiesUseCase] instance
  LoadActivitiesUseCase({
    required ActivityRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load all activities
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
  }) =>
      _repository.list(
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
      );
}
