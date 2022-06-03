import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// Represents the state of [QueueRequestCubit]
class QueueRequestStates extends Equatable {
  /// Last occurred error
  final QueueRequestStatesErrors error;

  /// Last performed action
  final QueueRequestStateActionResults action;

  /// The list of [QueueRequest]
  final UnmodifiableListView<QueueRequest> requests;

  /// Whether or not the cubit is busy loading the first set of queue requests
  final bool busyOnFirstLoad;

  /// Whether or not the cubit is busy loading data
  final bool busy;

  /// The current offset for the loaded list
  final int offset;

  /// Whether or not the cubit can load more data
  final bool canLoadMore;

  /// Creates a new [QueueRequestStates] instance
  QueueRequestStates({
    this.error = QueueRequestStatesErrors.none,
    this.action = QueueRequestStateActionResults.none,
    this.busy = false,
    this.busyOnFirstLoad = false,
    this.canLoadMore = false,
    this.offset = 0,
    Iterable<QueueRequest> requests = const [],
  }) : requests = UnmodifiableListView(requests);

  @override
  List<Object?> get props => [
        error,
        requests,
        busy,
        busyOnFirstLoad,
        offset,
        canLoadMore,
        action,
      ];

  /// Creates a new instance of [QueueRequestStates]
  /// based on the current instance
  QueueRequestStates copyWith({
    QueueRequestStatesErrors? error,
    QueueRequestStateActionResults? action,
    Iterable<QueueRequest>? requests,
    bool? busy,
    int? offset,
    bool? canLoadMore,
    bool? busyOnFirstLoad,
  }) {
    return QueueRequestStates(
      error: error ?? this.error,
      requests: requests ?? this.requests,
      busy: busy ?? this.busy,
      offset: offset ?? this.offset,
      canLoadMore: canLoadMore ?? this.canLoadMore,
      busyOnFirstLoad: busyOnFirstLoad ?? this.busyOnFirstLoad,
      action: action ?? this.action,
    );
  }
}

/// Represents all possible errors for [QueueRequestCubit]
enum QueueRequestStatesErrors {
  /// No error
  none,

  /// Generic error
  generic,

  /// Failed accepting request
  failedAccepting,

  /// Failed rejecting a request
  failedRejecting,

  /// Network error
  network,
}

/// Represents all the possible action result for this cubit
enum QueueRequestStateActionResults {
  /// No action performed
  none,

  /// Request was approved successfully
  approvedRequest,

  /// Request was rejected successfully
  rejectedRequest,
}
