import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the Queues/Requests data
class QueueRequestRepository {
  final QueueRequestProvider _provider;

  /// Creates a new [QueueRequestRepository] instance
  QueueRequestRepository(
    this._provider,
  );

  /// Retrieves a list of [QueueRequest] from the console service based
  /// on the supplied limit and offset
  Future<List<QueueRequest>> list({
    int limit = 50,
    int offset = 0,
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
  Future<bool> accept(
    String requestId, {
    required bool isRequest,
  }) {
    return _provider.accept(requestId, isRequest: isRequest);
  }

  /// Rejects a [QueueRequest] item
  Future<bool> reject(
    String requestId, {
    required bool isRequest,
  }) {
    return _provider.reject(requestId, isRequest: isRequest);
  }
}
