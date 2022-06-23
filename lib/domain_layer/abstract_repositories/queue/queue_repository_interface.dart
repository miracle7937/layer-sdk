import '../../models.dart';

/// An abstract repository for the Queues
abstract class QueueRepositoryInterface {
  /// Retrieves a list of [QueueRequest] from the console service
  ///
  /// Use `limit` and `offset` to paginate.
  Future<List<QueueRequest>> list({
    int? limit,
    int? offset,
    bool forceRefresh = true,
  });

  /// Accepts a [QueueRequest] item using the provided `requestId`.
  ///
  /// `isRequest` is used to determinate which `endpointUrl` is going to be used
  ///
  /// We have to options, if `isRequest` is `true` the `endpointUrl` will be
  /// `netEndpoints.requests`
  ///
  /// If is `false` the `endpointUrl` will be `netEndpoints.queueRequest`
  Future<bool> accept(
    String requestId, {
    required bool isRequest,
  });

  /// Reject a [QueueRequest] item using the provided `requestId`.
  ///
  /// `isRequest` is used to determinate which `endpointUrl` is going to be used
  ///
  /// We have to options, if `isRequest` is `true` the `endpointUrl` will be
  /// `netEndpoints.requests`
  ///
  /// If is `false` the `endpointUrl` will be `netEndpoints.queueRequest`
  Future<bool> reject(
    String requestId, {
    required bool isRequest,
  });
}
