import '../../abstract_repositories/limits/limits_repository_interface.dart';
import '../../models/limits/limits.dart';

/// Use case responsible for fetching the limits of a [Customer].
class LoadLimitsUseCase {
  /// Repository to load
  final LimitsRepositoryInterface limitsRepository;

  /// Creates a new [LoadLimitsUseCase] instance.
  const LoadLimitsUseCase({
    required LimitsRepositoryInterface repository,
  }) : limitsRepository = repository;

  /// Retrieves the list of [limits]s of the provided `customerId` or `agentId`.
  Future<Limits> call({
    String? customerId,
    String? agentId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) =>
      limitsRepository.load(
        customerId: customerId,
        agentId: agentId,
        forceRefresh: forceRefresh,
        offset: offset,
        limit: limit,
      );
}
