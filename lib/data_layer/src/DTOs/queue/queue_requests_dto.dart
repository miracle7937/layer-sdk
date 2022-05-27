import 'queue_dto.dart';
import 'request_dto.dart';

/// Response envelope that contains the list of queue items and request items
/// as provided by the infobanking service
class QueueRequestDTO {
  /// List of queue items.
  ///
  /// See [QueueDTO] for more details
  final List<QueueDTO>? queues;

  /// List of queue items.
  ///
  /// See [RequestDTO] for more details
  final List<RequestDTO>? requests;

  /// Creates a new [QueueRequestDTO] instance
  QueueRequestDTO({
    this.queues,
    this.requests,
  });

  /// Creates a new [QueueRequestDTO] from a JSON string
  factory QueueRequestDTO.fromJson(Map<String, dynamic> json) {
    return QueueRequestDTO(
      queues: QueueDTO.fromJsonList(json['queues']),
      requests: RequestDTO.fromJsonList(json['requests']),
    );
  }
}
