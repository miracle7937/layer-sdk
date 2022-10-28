import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'inbox_file.dart';

/// Class that holds data for report messages
class InboxReportMessage extends Equatable {
  /// Id of the report
  final int reportId;

  /// Id of the message
  final int? messageId;

  /// Time when the record was created
  final DateTime? tsCreated;

  /// Time when the record was updated
  final DateTime? tsUpdated;

  /// Files in the report
  final UnmodifiableListView<InboxFile> files;

  /// Id of the sender
  final int? sender;

  /// Type of the sender
  final InboxReportSenderType senderType;

  /// Text of the report
  final String text;

  /// A filtered list of file urls
  final UnmodifiableListView<String> attachmentUrls;

  /// If the report was read
  final bool? read;

  /// [InboxReportMessage] constructor
  InboxReportMessage({
    Iterable<InboxFile> files = const [],
    Iterable<String> attachmentUrls = const [],
    required this.reportId,
    this.messageId,
    this.sender,
    this.senderType = InboxReportSenderType.unknown,
    this.text = '',
    this.tsCreated,
    this.tsUpdated,
    this.read,
  })  : files = UnmodifiableListView(files),
        attachmentUrls = UnmodifiableListView(attachmentUrls);

  @override
  List<Object?> get props {
    return [
      reportId,
      messageId,
      tsCreated,
      tsUpdated,
      files,
      sender,
      senderType,
      text,
      attachmentUrls,
      read,
    ];
  }

  /// Creates copy of [InboxReportMessage]
  InboxReportMessage copyWith({
    int? reportId,
    int? messageId,
    DateTime? tsCreated,
    DateTime? tsUpdated,
    Iterable<InboxFile>? files,
    int? sender,
    InboxReportSenderType? senderType,
    String? text,
    Iterable<String>? attachmentUrls,
    bool? read,
  }) {
    return InboxReportMessage(
      reportId: reportId ?? this.reportId,
      messageId: messageId ?? this.messageId,
      tsCreated: tsCreated ?? this.tsCreated,
      tsUpdated: tsUpdated ?? this.tsUpdated,
      files: files ?? this.files,
      sender: sender ?? this.sender,
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      read: read ?? this.read,
    );
  }
}

/// Enum that holds the sender type
enum InboxReportSenderType {
  /// Public sender type
  public,

  /// Customer sender type
  customer,

  /// Unkown sender type
  unknown,
}
