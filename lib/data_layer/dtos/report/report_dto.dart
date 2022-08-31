import '../../../domain_layer/models/report/report.dart';
import '../../helpers.dart';

/// Report DTO
class ReportDTO {
  /// Report id
  int? id;

  /// Created at
  DateTime? tsCreated;

  /// Updated at
  DateTime? tsUpdated;

  /// Customer id
  String? customerID;

  /// Username
  String? username;

  /// Device id
  int? deviceID;

  /// Description
  String? description;

  /// Device info
  String? deviceInfo;

  /// files
  List<String>? files;

  /// UnmodifiedFiles
  List<String>? unmodifiedFiles;

  /// Status
  String? status;

  /// osVersion
  String? osVersion;

  /// Private note
  String? privateNote;

  /// Assignee
  String? assignee;

  /// Assignee first name
  String? assigneeFirstName;

  /// Assignee last name
  String? assigneeLastName;

  /// Category
  String? category;

  /// Category name
  String? categoryName;

  /// Extra
  Map<String, dynamic>? extra;

  /// Is read
  bool? read;

  /// Default constructor
  ReportDTO({
    this.id,
    this.tsCreated,
    this.tsUpdated,
    this.customerID,
    this.username,
    this.deviceID,
    this.description,
    this.deviceInfo,
    this.files,
    this.unmodifiedFiles,
    this.status,
    this.osVersion,
    this.privateNote,
    this.assignee,
    this.assigneeFirstName,
    this.assigneeLastName,
    this.category,
    this.categoryName,
    this.extra,
    this.read,
  });

  /// Constructor from json
  ReportDTO.fromJson(Map<String, dynamic> json) {
    id = json['report_id'];
    tsCreated = JsonParser.parseDate(json['ts_created']);
    tsUpdated = JsonParser.parseDate(json['ts_updated']);
    customerID = json['customer_id'];
    username = json['username'];
    deviceID = json['device_id'];
    description = json['description'];
    deviceInfo = json['device_info'];
    files = isNotEmpty(json['files'])
        ? json['files'].replaceAll(" ", "").split(',')
        : [];
    unmodifiedFiles = isNotEmpty(json['files']) ? json['files'].split(',') : [];

    files = files!.reversed.toList(growable: false);
    unmodifiedFiles = unmodifiedFiles!.reversed.toList(growable: false);

    ///filtering files with 'zip' and 'log' extensions
    files = files!
        .where((file) =>
            (file.split('.').last != 'log' && file.split('.').last != 'zip'))
        .toList(growable: false);

    unmodifiedFiles = unmodifiedFiles!
        .where((file) =>
            (file.split('.').last != 'log' && file.split('.').last != 'zip'))
        .toList(growable: false);

    status = json['status'];
    osVersion = json['os_version'];
    privateNote = json['private_note'];
    assignee = json['assignee'];
    assigneeFirstName = json['assignee_first_name'];
    assigneeLastName = json['assignee_last_name'];
    category = json['category'];
    categoryName = json['category_name'];
    extra = json['extra'] ?? {};
    read = json['read'] ?? false;
  }

  /// Get report dto list from json list
  static List<ReportDTO> fromJsonList(List<Map<String, dynamic>> json) {
    final reports = json.map(ReportDTO.fromJson).toList();
    return reports;
  }

  /// Return report
  Report toReport() {
    return Report(
      id: id,
      tsCreated: tsCreated,
      tsUpdated: tsUpdated,
      customerID: customerID,
      username: username,
      deviceID: deviceID,
      description: description,
      deviceInfo: deviceInfo,
      files: files,
      unmodifiedFiles: unmodifiedFiles,
      status: status,
      osVersion: osVersion,
      privateNote: privateNote,
      assignee: assignee,
      assigneeFirstName: assigneeFirstName,
      assigneeLastName: assigneeLastName,
      category: category,
      categoryName: categoryName,
      extra: extra,
      read: read,
    );
  }
}
