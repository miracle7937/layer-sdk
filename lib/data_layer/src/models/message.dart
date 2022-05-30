import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Message
class Message extends Equatable {
  /// Message id
  final String? id;

  /// Message module
  final String? module;

  /// Message's message
  final String? message;

  /// Creates a new immutable [Message]
  Message({
    this.id,
    this.module,
    this.message,
  });

  @override
  List<Object?> get props => [
        id,
        module,
        message,
      ];
}

/// Returns the message whose id is the same as the one passed
extension MessageListExtension on List<Message> {
  /// Returns the message needed
  Message? get(String id) => firstWhereOrNull(
        (message) => message.id == id,
      );
}
