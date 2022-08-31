import '../../dtos.dart';
import '../../helpers/dto_helpers.dart';
import '../../helpers/json_parser.dart';

/// Class that contains data for Inbox messages
class InboxReportMessageDTO {
  /// Id of the report
  int? reportId;

  /// Id of the message
  int? messageId;

  /// Time when the record was created
  DateTime? tsCreated;

  /// Time when the record was updated
  DateTime? tsUpdated;

  /// Files in the report
  String? files;

  /// Id of the sender
  int? sender;

  /// Type of the sender
  InboxReportSenderTypeDTO? senderType;

  /// Text of the report
  String? text;

  /// A filtered list of file urls
  List<String>? attachmentUrls;

  /// If the report was read
  bool? read;

  /// Creates a new [InboxReportMessageDTO]
  InboxReportMessageDTO({
    this.reportId,
    this.messageId,
    this.tsCreated,
    this.tsUpdated,
    this.files,
    this.sender,
    this.senderType,
    this.text,
    this.attachmentUrls,
    this.read,
  });

  /// Parse a json map into a [InboxReportMessageDTO] instance
  factory InboxReportMessageDTO.fromJson(Map<String, dynamic> json) {
    return InboxReportMessageDTO(
      reportId: json['report_id'],
      tsCreated: JsonParser.parseDate(json['ts_created']),
      tsUpdated: JsonParser.parseDate(json['ts_updated']),
      messageId: json['message_id'],
      text: json['text'],
      sender: json['sender'],
      senderType: InboxReportSenderTypeDTO.fromRaw(json['sender_type']),
      files: json['files'],
      read: json['read'],
      attachmentUrls: json['attachment_url'],
    );
  }

  /// Parses a list of json into a list of [InboxReportMessageDTO]
  static List<InboxReportMessageDTO> fromJsonList(
    List<Map<String, dynamic>> jsonList,
  ) {
    return jsonList
        .map(InboxReportMessageDTO.fromJson)
        .where(
          (m) => isNotEmpty(m.text) || (m.attachmentUrls?.isNotEmpty ?? false),
        )
        .toList(growable: false);
  }
}
