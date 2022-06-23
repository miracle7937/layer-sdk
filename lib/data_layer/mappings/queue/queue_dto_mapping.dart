import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mapping for [QueueDTO]
extension QueueDTOMapping on QueueDTO {
  /// Maps a [QueueDTO] to a [QueueRequest] instance
  QueueRequest toQueueRequest() {
    final _log = Logger('QueueDTOMapping');
    final decodedBody = <Map<String, dynamic>>[];

    if (body != null) {
      final data = body is List ? body : [body];

      data.forEach(
        (v) => v is Map<String, dynamic>
            ? decodedBody.add(v)
            : _log.warning('Ignored value "$v" of type ${v.runtimeType}'),
      );
    }

    return QueueRequest(
      body: decodedBody,
      creationDate: creationDate,
      id: id?.toString(),
      makerId: makerId,
      url: url,
      queueOperation: operation?.toQueueOperation(),
      requestMethod: null,
      isRequest: false,
    );
  }
}

/// Extension that provides mapping
extension QueueOperationMapping on QueueDTOOperation {
  /// Maps a [QueueDTOOperation] to a [QueueOperation]
  QueueOperation toQueueOperation() {
    switch (this) {
      case QueueDTOOperation.add:
        return QueueOperation.add;

      case QueueDTOOperation.delete:
        return QueueOperation.delete;

      case QueueDTOOperation.update:
      case QueueDTOOperation.update2:
        return QueueOperation.update;

      default:
        throw MappingException(from: QueueDTOOperation, to: QueueOperation);
    }
  }
}
