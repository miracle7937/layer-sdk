import '../../abstract_repositories/queue/queue_repository_interface.dart';

/// Use case to reject the [Queue]
class RejectQueueUseCase {
  final QueueRepositoryInterface _repository;

  /// Creates a new [RejectQueueUseCase] instance
  RejectQueueUseCase({
    required QueueRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to reject the [Queue]
  Future<bool> call(
    String requestId, {
    required bool isRequest,
  }) =>
      _repository.reject(requestId, isRequest: isRequest);
}
