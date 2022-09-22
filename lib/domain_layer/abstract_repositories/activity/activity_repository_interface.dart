import '../../models.dart';

/// An abstract repository for [Activity]
abstract class ActivityRepositoryInterface {
  /// List all activities
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
  });

  /// Delete a certain activity based on the id
  Future<void> delete(String activityId);

  /// Cancel the [Activity] by `id`
  Future<void> cancel(String id, {String? otpValue});

  /// Cancel the recurring transfer [Activity] by `id`
  Future<void> cancelRecurringTransfer(String id, {String? otpValue});
}