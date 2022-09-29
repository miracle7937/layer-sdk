import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Create report action
enum CreateReportAction {
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
class CreateReportState extends Equatable {
  /// Busy action
  final CreateReportAction action;

  /// Error status
  final CreateReportErrorStatus error;

  /// Created report
  final InboxReport? createdReport;

  /// Copy with method
  CreateReportState copyWith({
    CreateReportAction? action,
    CreateReportErrorStatus? error,
    String? category,
    InboxReport? createdReport,
  }) =>
      CreateReportState(
        action: action ?? this.action,
        error: error ?? this.error,
        createdReport: createdReport ?? this.createdReport,
      );

  /// Default constructor
  CreateReportState({
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
