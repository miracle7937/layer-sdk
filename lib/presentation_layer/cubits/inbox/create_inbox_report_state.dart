import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models/inbox/inbox_report.dart';

/// Create report action
enum CreateInboxReportAction {
  /// No actions
  none,

  ///Creating report
  creating
}

/// Create report error status
enum CreateReportErrorStatus {
  /// No error
  none,

  /// Generic error
  generic,

  /// Network error
  network
}

/// Create report state
class CreateInboxReportState extends Equatable {
  /// Busy action
  final CreateInboxReportAction action;

  /// Error status
  final CreateReportErrorStatus error;

  /// Created report
  final InboxReport? createdReport;

  /// Copy with method
  CreateInboxReportState copyWith({
    CreateInboxReportAction? action,
    CreateReportErrorStatus? error,
    String? category,
    InboxReport? createdReport,
  }) =>
      CreateInboxReportState(
        action: action ?? this.action,
        error: error ?? this.error,
        createdReport: createdReport ?? this.createdReport,
      );

  /// Default constructor
  CreateInboxReportState({
    required this.action,
    required this.error,
    this.createdReport,
  });

  @override
  List<Object?> get props => [
        action,
        error,
        createdReport,
      ];
}
