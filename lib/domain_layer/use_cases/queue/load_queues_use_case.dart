import '../../abstract_repositories/queue/queue_repository_interface.dart';
import '../../models.dart';

/// Use case to load all [Queue]s
class LoadQueuesUseCase {
  final QueueRepositoryInterface _repository;

  /// Creates a new [LoadQueuesUseCase] instance
  LoadQueuesUseCase({
    required QueueRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to load all [Queue]s
  Future<List<QueueRequest>> call({
    int limit = 50,
    int offset = 0,
    bool forceRefresh = true,
  }) =>
      _repository.list(
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
      );
}
