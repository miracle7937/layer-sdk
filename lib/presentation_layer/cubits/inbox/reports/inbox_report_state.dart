import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';
import '../../../utils.dart';

///  The available error status
enum InboxReportErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Which loading action the cubit is doing
enum InboxReportBusyAction {
  /// if loading the first time
  loading,

  /// If is loading more data
  loadingMore,

  /// If is making a report as read
  markingAsRead,

  /// If is doing nothing
  none
}

/// State for [InboxReportCubit]
class InboxReportState extends Equatable {
  /// If the cubit is busy
  final bool busy;

  /// The busy action
  final InboxReportBusyAction? busyAction;

  /// The error status
  final InboxReportErrorStatus errorStatus;

  /// The error Message
  final String errorMessage;

  /// A list of reports
  final UnmodifiableListView<InboxReport> reports;

  /// Handle the data pagination
  final Pagination pagination;

  /// Creates a new [InboxReportState] instance
  InboxReportState({
    this.busyAction,
    this.errorStatus = InboxReportErrorStatus.none,
    this.errorMessage = '',
    this.pagination = const Pagination(limit: 10),
    Iterable<InboxReport> reports = const [],
    this.busy = false,
  }) : reports = UnmodifiableListView(reports);

  @override
  List<Object?> get props {
    return [
      busy,
      busyAction,
      errorStatus,
      errorMessage,
      reports,
      pagination,
    ];
  }

  /// Makes a copy of [InboxReportState]
  InboxReportState copyWith({
    bool? busy,
    InboxReportBusyAction? busyAction,
    InboxReportErrorStatus? errorStatus,
    String? errorMessage,
    Iterable<InboxReport>? reports,
    Pagination? pagination,
  }) {
    return InboxReportState(
      busy: busy ?? this.busy,
      busyAction: busyAction ?? this.busyAction,
      errorStatus: errorStatus ?? this.errorStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      reports: reports ?? this.reports,
      pagination: pagination ?? this.pagination,
    );
  }
}
