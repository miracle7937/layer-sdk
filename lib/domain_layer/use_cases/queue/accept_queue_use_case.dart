import '../../abstract_repositories.dart';

/// Use case to accept the [Queue]
class AcceptQueueUseCase {
  final QueueRepositoryInterface _repository;

  /// Creates a new [AcceptQueueUseCase] instance
  AcceptQueueUseCase({
    required QueueRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to accepts a [QueueRequest] item
  /// using the provided `requestId`.
  ///
  /// `isRequest` is used to determinate which `endpointUrl` is going to be used
  ///
  /// We have to options, if `isRequest` is `true` the `endpointUrl` will be
  /// `netEndpoints.requests`
  ///
  /// If is `false` the `endpointUrl` will be `netEndpoints.queueRequest`
  Future<bool> call(
    String requestId, {
    required bool isRequest,
  }) =>
      _repository.accept(requestId, isRequest: isRequest);
}
