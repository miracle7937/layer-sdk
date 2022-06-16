import '../../abstract_repositories.dart';

/// Use case to accept the [Queue]
class AcceptQueueUseCase {
  final QueueRepositoryInterface _repository;

  /// Creates a new [AcceptQueueUseCase] instance
  AcceptQueueUseCase({
    required QueueRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to accept the [Queue]
  Future<bool> call(
    String requestId, {
    required bool isRequest,
  }) =>
      _repository.accept(requestId, isRequest: isRequest);
}
