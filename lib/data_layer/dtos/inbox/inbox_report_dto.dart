import '../../dtos.dart';
import '../../helpers.dart';

/// Data class that holds data for inbox reports
class InboxReportDTO {
  /// The report ID
  int? id;

  /// When the record was created
  DateTime? tsCreated;

  /// When the record was updated
  DateTime? tsUpdated;

  /// The Customer id
  String? customerID;

  /// A username
  String? username;

  /// The ID of the current device
  int? deviceID;

  /// The description text of this report
  String? description;

  /// Information about this device
  String? deviceInfo;

  /// A list of files contained in this report
  List<String>? files;

  /// The status of the report
  InboxReportStatusDTO? status;

  /// The OS version
  String? osVersion;

  /// A private note
  String? privateNote;

  /// Who is the assignee
  String? assignee;

  /// First name of the report assignee
  String? assigneeFirstName;

  /// Last name of the report assignee
  String? assigneeLastName;

  /// Report category
  InboxReportCategoryDTO? category;

  /// The report category name
  String? categoryName;

  /// A list of messages contained in this report
  List<InboxReportMessageDTO>? messages;

  /// If the report was read
  bool? read;

  /// a Json map for holding extra data
  Map<String, Object>? extra;

  /// [InboxReportDTO] constructor
  InboxReportDTO({
    this.id,
    this.tsCreated,
    this.tsUpdated,
    this.customerID,
    this.username,
    this.deviceID,
    this.description,
    this.deviceInfo,
    this.files,
    this.status,
    this.osVersion,
    this.privateNote,
    this.assignee,
    this.assigneeFirstName,
    this.assigneeLastName,
    this.category,
    this.categoryName,
    this.messages,
    this.read,
    this.extra,
  });

  /// Returns a [InboxReportDTO] a json map
  factory InboxReportDTO.fromJson(Map<String, dynamic> json) {
    return InboxReportDTO(
      id: json['report_id'],
      tsCreated: JsonParser.parseDate(json['ts_created']),
      tsUpdated: JsonParser.parseDate(json['ts_updated']),
      customerID: json['customer_id'],
      username: json['username'],
      deviceID: json['device_id'],
      description: json['description'],
      deviceInfo: json['device_info'],
      files: isNotEmpty(json['files'])
          ? json['files'].replaceAll(" ", "").split(',')
          : [],
      status: InboxReportStatusDTO.fromRaw(json['status']),
      osVersion: json['os_version'],
      privateNote: json['private_note'],
      assignee: json['assignee'],
      assigneeFirstName: json['assignee_first_name'],
      assigneeLastName: json['assignee_last_name'],
      category: InboxReportCategoryDTO.fromRaw(json['category']),
      categoryName: json['category_name'],
      messages: json['messages'] != null
          ? InboxReportMessageDTO.fromJsonList(json['messages'])
          : null,
      extra: json['extra'] ?? {},
      read: json['read'] ?? false,
    );
  }

  /// Returns a list of [InboxReportDTO] from a JSON
  static List<InboxReportDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(InboxReportDTO.fromJson).toList();
}
