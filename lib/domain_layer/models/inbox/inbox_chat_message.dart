// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../models.dart';

/// Class that holds data related to inbox chat screen messages
class InboxChatMessage {
  /// The status of the message
  final InboxChatMessageStatus? status;

  /// The message of the report
  final InboxReportMessage message;

  /// When it was send
  final DateTime? sentTime;

  /// Creates a new [InboxChatMessage] instance
  InboxChatMessage({
    required this.message,
    this.status,
    this.sentTime,
  });

  InboxChatMessage copyWith({
    InboxChatMessageStatus? status,
    InboxReportMessage? message,
    DateTime? sentTime,
  }) {
    return InboxChatMessage(
      status: status ?? this.status,
      message: message ?? this.message,
      sentTime: sentTime ?? this.sentTime,
    );
  }
}
