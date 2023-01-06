import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for fetching the limits of a [Customer].
class SaveLimitsUseCase {
  /// Repository to load
  final LimitsRepositoryInterface limitsRepository;

  /// Creates a new [SaveLimitsUseCase] instance.
  const SaveLimitsUseCase({
    required LimitsRepositoryInterface repository,
  }) : limitsRepository = repository;

  /// Retrieves the list of [limits]s of the provided `customerId` or `agentId`.
  Future<QueueRequest> call({
    String? customerId,
    String? agentId,
    required CustomerType customerType,
    required Limits limits,
    bool hadLimits = true,
  }) {
    return limitsRepository.save(
      customerId: customerId,
      agentId: agentId,
      customerType: customerType,
      limits: limits,
    );
  }
}
