import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

///  The available error status
enum DeleteReportErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Delete report action
enum DeleteInboxReportAction {
  /// No actions
  none,

  ///Deleting report
  deleting
}

/// Delete report state
class DeleteInboxReportState extends Equatable {
  /// Busy action
  final DeleteInboxReportAction action;

  /// Error status
  final DeleteReportErrorStatus error;

  /// Created report
  final InboxReport? deletedReport;

  /// Copy with method
  DeleteInboxReportState copyWith({
    DeleteInboxReportAction? action,
    DeleteReportErrorStatus? error,
    String? category,
    InboxReport? deletedReport,
  }) =>
      DeleteInboxReportState(
        action: action ?? this.action,
        error: error ?? this.error,
        deletedReport: deletedReport ?? this.deletedReport,
      );

  /// Default constructor
  DeleteInboxReportState({
    required this.action,
    required this.error,
    this.deletedReport,
  });

  @override
  List<Object?> get props => [
        action,
        error,
        deletedReport,
      ];
}
