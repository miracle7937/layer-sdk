import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../dtos.dart';

/// All possible operations for queues
enum QueueOperation {
  /// Add operation
  add,

  /// Update operation
  update,

  /// Delete operation
  delete,
}

/// A Queue or Request item made by a [User]
class QueueRequest extends Equatable {
  /// Unique Queue/Request identifier
  final String? id;

  /// User ID of the request maker
  final String? makerId;

  /// Request method used by this Request
  ///
  /// Is null if this object was mapped from a [QueueDTO]
  final String? requestMethod;

  /// Operation to be done by this Queue
  ///
  /// Is null if this object was mapped from a [RequestDTO]
  final QueueOperation? queueOperation;

  /// Creation date of this Queue/Request
  final DateTime? creationDate;

  /// List of Map with the Queue/Request data
  final UnmodifiableListView<UnmodifiableMapView<String, dynamic>> body;

  /// The  url used by this Queue/Request item
  final String? url;

  /// Whether or not this is a request item
  final bool isRequest;

  /// Creates a new [QueueRequest] instance
  QueueRequest({
    this.id,
    this.makerId,
    this.queueOperation,
    this.requestMethod,
    this.creationDate,
    Iterable<Map<String, dynamic>> body = const [],
    this.url,
    this.isRequest = false,
  }) : body = UnmodifiableListView(
          body.map((element) => UnmodifiableMapView(element)).toList(),
        );

  @override
  List<Object?> get props => [
        id,
        makerId,
        queueOperation,
        requestMethod,
        creationDate,
        body,
        url,
        isRequest,
      ];
}
