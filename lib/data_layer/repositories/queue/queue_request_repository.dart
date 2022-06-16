import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the Queues/Requests data
class QueueRequestRepository implements QueueRepositoryInterface {
  final QueueRequestProvider _provider;

  /// Creates a new [QueueRequestRepository] instance
  QueueRequestRepository(
    this._provider,
  );

  /// Retrieves a list of [QueueRequest] from the console service based
  /// on the supplied limit and offset
  @override
  Future<List<QueueRequest>> list({
    int? limit,
    int? offset,
    bool forceRefresh = true,
  }) async {
    final queueRequestDTO = await _provider.list(
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
    );

    final queues = queueRequestDTO.queues
            ?.map(
              (x) => x.toQueueRequest(),
            )
            .toList() ??
        [];
    final requests = queueRequestDTO.requests
            ?.map(
              (x) => x.toQueueRequest(),
            )
            .toList() ??
        [];

    queues.addAll(requests);

    // Sort the items in a descending order
    queues.sort((b, a) {
      if (a.creationDate == null) return 1;
      if (b.creationDate == null) return -1;
      return a.creationDate!.compareTo(b.creationDate!);
    });

    return queues;
  }

  /// Accepts a [QueueRequest] item
  @override
  Future<bool> accept(
    String requestId, {
    required bool isRequest,
  }) {
    return _provider.accept(requestId, isRequest: isRequest);
  }

  /// Rejects a [QueueRequest] item
  @override
  Future<bool> reject(
    String requestId, {
    required bool isRequest,
  }) {
    return _provider.reject(requestId, isRequest: isRequest);
  }
}
