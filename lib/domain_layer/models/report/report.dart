/// Report model
class Report {
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
  Report({
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
}
