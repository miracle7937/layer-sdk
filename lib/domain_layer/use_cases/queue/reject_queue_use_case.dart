import '../../abstract_repositories.dart';

/// Use case to reject the [Queue]
class RejectQueueUseCase {
  final QueueRepositoryInterface _repository;

  /// Creates a new [RejectQueueUseCase] instance
  RejectQueueUseCase({
    required QueueRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable methot to reject a [QueueRequest] item
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
      _repository.reject(requestId, isRequest: isRequest);
}
