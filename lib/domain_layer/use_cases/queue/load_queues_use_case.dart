import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to load all [Queue]s
class LoadQueuesUseCase {
  final QueueRepositoryInterface _repository;

  /// Creates a new [LoadQueuesUseCase] instance
  LoadQueuesUseCase({
    required QueueRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load all [Queue]s
  ///
  /// Use `limit` and `offset` to paginate.
  Future<List<QueueRequest>> call({
    int? limit,
    int? offset,
    bool forceRefresh = true,
  }) =>
      _repository.list(
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
      );
}
