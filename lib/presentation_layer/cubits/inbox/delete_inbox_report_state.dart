import 'package:equatable/equatable.dart';

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

  /// Copy with method
  DeleteInboxReportState copyWith({
    DeleteInboxReportAction? action,
    DeleteReportErrorStatus? error,
    String? category,
  }) =>
      DeleteInboxReportState(
        action: action ?? this.action,
        error: error ?? this.error,
      );

  /// Default constructor
  DeleteInboxReportState({
    required this.action,
    required this.error,
  });

  @override
  List<Object?> get props => [
        action,
        error,
      ];
}
