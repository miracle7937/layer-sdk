import 'package:equatable/equatable.dart';

/// Report model
class Report extends Equatable {
  /// Report id
  final int? id;

  /// Created at
  final DateTime? tsCreated;

  /// Updated at
  final DateTime? tsUpdated;

  /// Customer id
  final String? customerID;

  /// Username
  final String? username;

  /// Device id
  final int? deviceID;

  /// Description
  final String? description;

  /// Device info
  final String? deviceInfo;

  /// files
  final List<String>? files;

  /// UnmodifiedFiles
  final List<String>? unmodifiedFiles;

  /// Status
  final String? status;

  /// osVersion
  final String? osVersion;

  /// Private note
  final String? privateNote;

  /// Assignee
  final String? assignee;

  /// Assignee first name
  final String? assigneeFirstName;

  /// Assignee last name
  final String? assigneeLastName;

  /// Category
  final String? category;

  /// Category name
  final String? categoryName;

  /// Extra
  final Map<String, dynamic>? extra;

  /// Is read
  final bool? read;

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

  @override
  List<Object?> get props => [
        id,
        tsCreated,
        tsUpdated,
        customerID,
        username,
        deviceID,
        description,
        deviceInfo,
        files,
        unmodifiedFiles,
        status,
        osVersion,
        privateNote,
        assignee,
        assigneeFirstName,
        assigneeLastName,
        category,
        categoryName,
        extra,
        read,
      ];
}
