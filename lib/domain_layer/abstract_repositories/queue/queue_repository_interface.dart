import '../../models.dart';

/// An abstract repository for the Queues
abstract class QueueRepositoryInterface {
  /// Retrieves a list of [QueueRequest] from the console service based
  /// on the supplied limit and offset
  Future<List<QueueRequest>> list({
    int limit = 50,
    int offset = 0,
    bool forceRefresh = true,
  });

  /// Accepts a [QueueRequest] item
  Future<bool> accept(
    String requestId, {
    required bool isRequest,
  });

  /// Rejects a [QueueRequest] item
  Future<bool> reject(
    String requestId, {
    required bool isRequest,
  });
}
