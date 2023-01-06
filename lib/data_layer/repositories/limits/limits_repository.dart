import '../../../domain_layer/abstract_repositories/limits/limits_repository_interface.dart';
import '../../../domain_layer/models/customer/customer.dart';
import '../../../domain_layer/models/limits/limits.dart';
import '../../../layer_sdk.dart';
import '../../mappings/customer/customer_type_extension.dart';
import '../../mappings/limits/limits_mapping.dart';
import '../../mappings/queue/queue_dto_mapping.dart';
import '../../providers/limits/limits_provider.dart';

/// Handles all the limits data
class LimitsRepository implements LimitsRepositoryInterface {
  final LimitsProvider _provider;

  /// Creates a new repository with the supplied [LimitsProvider]
  LimitsRepository({required LimitsProvider limitsProvider})
      : _provider = limitsProvider;

  /// Loads limits for provided [customerId] or [agentId].
  ///
  /// Can be used by [Customer]'s or [Agent]'s
  @override
  Future<Limits> load({
    String? customerId,
    String? agentId,
    bool forceRefresh = false,
    int limit = 50,
    int offset = 0,
  }) async {
    final limitsDTO = await _provider.load(
      customerId: customerId,
      agentId: agentId,
      forceRefresh: forceRefresh,
      offset: offset,
      limit: limit,
    );

    return limitsDTO.toLimits();
  }

  /// Saves provided [limits] information.
  /// If [Customer] with [customerId] or [Agent] with [agentId]
  /// already [hadLimits].
  @override
  Future<QueueRequest> save({
    String? customerId,
    String? agentId,
    required CustomerType customerType,
    required Limits limits,
    bool hadLimits = true,
  }) async {
    final dto = await _provider.save(
      customerId: customerId,
      agentId: agentId,
      customerType: customerType.toCustomerDTOType(),
      limitsDTO: limits.toLimitsDTO(),
      edit: hadLimits,
    );

    return dto.toQueueRequest();
  }
}
