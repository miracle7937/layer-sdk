// ignore_for_file: public_member_api_docs, sort_constructors_first

/// DTO used for sending a new report message
class InboxNewMessageDTO {
  /// The id of the InboxReport
  final int reportId;

  /// Text to be sent
  final String messageText;

  /// [InboxNewMessageDTO] Constructor
  InboxNewMessageDTO({
    required this.reportId,
    required this.messageText,
  });

  Map<String, Object> toJson() {
    return <String, Object>{
      'report_id': reportId,
      'text': messageText,
    };
  }
}
