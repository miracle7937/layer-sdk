import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to load all [Transfer]s
class LoadTransfersUseCase {
  final TransferRepositoryInterface _repository;

  /// Creates a new [LoadTransfersUseCase] instance
  LoadTransfersUseCase({
    required TransferRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load all [Transfer]s from a `customerId`
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Transfer>> call({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool includeDetails = true,
    bool recurring = false,
    bool forceRefresh = false,
  }) =>
      _repository.list(
        customerId: customerId,
        limit: limit,
        offset: offset,
        includeDetails: includeDetails,
        recurring: recurring,
        forceRefresh: forceRefresh,
      );
}
