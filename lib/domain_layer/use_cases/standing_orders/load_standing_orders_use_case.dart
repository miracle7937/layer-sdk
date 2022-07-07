import '../../abstract_repositories.dart';
import '../../models.dart';

/// An use case to load standing orders
class LoadStandingOrdersUseCase {
  final StandingOrdersRepositoryInterface _repository;

  /// Creates a new [LoadStandingOrdersUseCase] instance
  LoadStandingOrdersUseCase({
    required StandingOrdersRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to lists the standing orders from a `customerId`.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<StandingOrder>> call({
    required String customerId,
    int? limit,
    int? offset,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) =>
      _repository.list(
        customerId: customerId,
        limit: limit,
        offset: offset,
        includeDetails: includeDetails,
        forceRefresh: forceRefresh,
      );
}
