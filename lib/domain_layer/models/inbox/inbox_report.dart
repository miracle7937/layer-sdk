import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Data class that holds data for inbox reports
class InboxReport extends Equatable {
  /// The report ID
  final int id;

  /// When the record was created
  final DateTime? tsCreated;

  /// When the record was updated
  final DateTime? tsUpdated;

  /// The Customer id
  final String customerID;

  /// A username
  final String username;

  /// The ID of the current device
  final int deviceID;

  /// The description text of this report
  final String description;

  /// Information about this device
  final String deviceInfo;

  /// A list of files contained in this report
  final UnmodifiableListView<String> files;

  /// The status of the report
  final InboxReportStatus status;

  /// The OS version
  final String osVersion;

  /// A private note
  final String privateNote;

  /// Who is the assignee
  final String assignee;

  /// First name of the report assignee
  final String assigneeFirstName;

  /// Last name of the report assignee
  final String assigneeLastName;

  /// Report category
  final InboxReportCategory category;

  /// The report category name
  final String categoryName;

  /// A list of messages contained in this report
  final UnmodifiableListView<InboxReportMessage> messages;

  /// If the report was read
  final bool read;

  /// a Json map for holding extra data
  final Map<String, dynamic>? extra;

  /// [InboxReport] constructor
  InboxReport({
    required this.id,
    required this.customerID,
    required this.deviceID,
    Iterable<String> files = const [],
    Iterable<InboxReportMessage> messages = const [],
    this.username = '',
    this.description = '',
    this.deviceInfo = '',
    this.status = InboxReportStatus.unknown,
    this.osVersion = '',
    this.privateNote = '',
    this.assignee = '',
    this.assigneeFirstName = '',
    this.assigneeLastName = '',
    this.category = InboxReportCategory.other,
    this.categoryName = '',
    this.read = false,
    this.tsCreated,
    this.tsUpdated,
    this.extra,
  })  : files = UnmodifiableListView(files),
        messages = UnmodifiableListView(messages);

  /// Creates a copy of [InboxReport]
  InboxReport copyWith({
    int? id,
    DateTime? tsCreated,
    DateTime? tsUpdated,
    String? customerID,
    String? username,
    int? deviceID,
    String? description,
    String? deviceInfo,
    Iterable<String>? files,
    String? osVersion,
    String? privateNote,
    String? assignee,
    String? assigneeFirstName,
    String? assigneeLastName,
    String? categoryName,
    Iterable<InboxReportMessage>? messages,
    bool? read,
    Map<String, Object>? extra,
  }) {
    return InboxReport(
      id: id ?? this.id,
      tsCreated: tsCreated ?? this.tsCreated,
      tsUpdated: tsUpdated ?? this.tsUpdated,
      customerID: customerID ?? this.customerID,
      username: username ?? this.username,
      deviceID: deviceID ?? this.deviceID,
      description: description ?? this.description,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      files: files ?? this.files,
      osVersion: osVersion ?? this.osVersion,
      privateNote: privateNote ?? this.privateNote,
      assignee: assignee ?? this.assignee,
      assigneeFirstName: assigneeFirstName ?? this.assigneeFirstName,
      assigneeLastName: assigneeLastName ?? this.assigneeLastName,
      categoryName: categoryName ?? this.categoryName,
      messages: messages ?? this.messages,
      read: read ?? this.read,
      extra: extra ?? this.extra,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      tsCreated,
      tsUpdated,
      customerID,
      username,
      deviceID,
      description,
      deviceInfo,
      files,
      osVersion,
      privateNote,
      assignee,
      assigneeFirstName,
      assigneeLastName,
      categoryName,
      messages,
      read,
      extra,
    ];
  }
}

/// Enum that represents the status of the report
enum InboxReportStatus {
  /// Status Deleted
  deleted,

  /// Status Closed,
  closed,

  /// Status Unknown
  unknown,
}

/// Enum that holds the category of the report
enum InboxReportCategory {
  /// AppointmentReview category
  appointmentReview,

  /// ArticleFeedback category
  articleFeedback,

  /// OfferInquiry category
  offerInquiry,

  /// ProductInquiry category
  productInquiry,

  /// GeneralComments category
  generalComments,

  /// AppIssue category
  appIssue,

  /// Other category
  other,
}
