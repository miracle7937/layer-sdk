import 'dart:convert';

import 'package:collection/collection.dart';

import '../../helpers.dart';

/// The available Queue Operations
class QueueDTOOperation extends EnumDTO {
  /// Update operation
  static const update = QueueDTOOperation._internal('A');

  /// Update Operation
  /// For some reason the API also uses "U" as update operation
  static const update2 = QueueDTOOperation._internal('U');

  /// Add operation
  static const add = QueueDTOOperation._internal('O');

  /// Delete operation
  static const delete = QueueDTOOperation._internal('D');

  /// All the available queue operations
  static const List<QueueDTOOperation> values = [
    update,
    update2,
    add,
    delete,
  ];

  const QueueDTOOperation._internal(String value) : super.internal(value);

  /// Creates a [QueueDTOOperation] from a [String]
  static QueueDTOOperation? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

/// Represents a Queue item
/// as provided by the infobanking service
class QueueDTO {
  /// Unique identifier for the queue item
  final num? id;

  /// The operation to be done by this queue item
  final QueueDTOOperation? operation;

  /// User ID of the request maker
  final String? makerId;

  /// Creation date of this request
  final DateTime? creationDate;

  /// JSON String with the request data
  final dynamic body;

  /// URL of this queue item
  final String? url;

  /// Creates a new [QueueDTO] instance
  QueueDTO({
    this.id,
    this.operation,
    this.makerId,
    this.creationDate,
    this.body,
    this.url,
  });

  /// Creates a new [QueueDTO] instance from a JSON
  factory QueueDTO.fromJson(Map<String, dynamic> map) {
    return QueueDTO(
      id: map['queue_id'],
      operation: QueueDTOOperation.fromRaw(map['operation']),
      makerId: map['maker_id'],
      creationDate: JsonParser.parseDate(map['make_ts']),
      body: map['body'] != null ? jsonDecode(map['body']) : null,
      url: map['url'],
    );
  }

  /// Creates a new [QueueDTO] list instance from a JSON list
  static List<QueueDTO> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map(QueueDTO.fromJson).toList(growable: false);
  }
}
