import '../../models.dart';

/// The abstract repository for the audits.
abstract class LimitsRepositoryInterface {
  /// Loads limits for provided [customerId] or [agentId]
  ///
  /// Can be used by [Customer]'s or [Agent]'s
  Future<Limits> load({
    String? customerId,
    String? agentId,
    bool forceRefresh = false,
    int limit = 50,
    int offset = 0,
  });

  /// Saves provided [limits] information.
  /// If [Customer] with [customerId] or [Agent] with [agentId]
  /// already [hadLimits].
  Future<QueueRequest> save({
    String? customerId,
    String? agentId,
    required CustomerType customerType,
    required Limits limits,
    bool hadLimits = true,
  });
}
