import '../../../models.dart';
import '../../DTOs/queue/request_dto.dart';

/// Extension that provides mapping for [QueueDTO]
extension RequestDTOMapping on RequestDTO {
  /// Maps a [RequestDTO] to a [QueueRequest] instance
  QueueRequest toQueueRequest() {
    final decodedBody = <Map<String, dynamic>>[];
    if (body != null) {
      if (body is List) {
        body.forEach(decodedBody.add);
      } else {
        decodedBody.add(body);
      }
    }

    return QueueRequest(
      body: decodedBody,
      creationDate: creationDate,
      id: id.toString(),
      makerId: makerId,
      url: requestUrl,
      requestMethod: requestMethod,
      queueOperation: null,
      isRequest: true,
    );
  }
}
