import 'package:collection/collection.dart';

import '../../models.dart';

/// Use case to remove [Queue] from request list
class RemoveQueueFromRequestsUseCase {
  /// Callable method to remove [Queue] from request list
  List<QueueRequest> call({
    required UnmodifiableListView<QueueRequest> requests,
    required String requestId,
  }) =>
      requests.where((x) => x.id != requestId).toList();
}
