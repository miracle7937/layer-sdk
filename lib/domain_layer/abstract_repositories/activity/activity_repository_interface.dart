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

  /// Read the current [Alert] by respective `id`
  Future<void> markAlertAsRead(int id);

  /// Read the current [Request] by respective `id`
  Future<void> markRequestAsRead(String id);

  /// Delete the current [Alert] by respective `id`
  Future<void> deleteAlert(int id);

  /// Delete the current [Request] by respective `id`
  Future<void> deleteRequest(String id);

  /// Read all the [Alert]'s
  Future<void> markAllAlertsAsRead();

  /// Read all the [Request]'s
  Future<void> markAllRequestsAsRead();

  /// Delete all the [Alert]'s
  Future<void> deleteAllAlerts();

  /// Delete all the [Request]'s
  Future<void> deleteAllRequests();
}
