import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart' show immutable;
import '../../../../data_layer/data_layer.dart';

import '../../utils/pagination.dart';

/// Possible errors emitted by the state
enum AppointmentBranchStateError {
  /// No error
  none,

  /// Network error
  network,

  /// Any other error
  generic,
}

/// Which loading action the cubit is doing
enum AppointBranchBusyAction {
  /// if loading the first time
  loading,

  /// If is loading more data
  loadingMore,
}

/// Class that holds a list of possible branches and a selected branch
@immutable
class AppointmentBranchState extends Equatable {
  /// List of branches
  final UnmodifiableListView<Branch> branches;

  /// Type of error
  final AppointmentBranchStateError error;

  /// Error message
  final String errorMessage;

  /// If the cubit is doing any action
  final bool busy;

  /// Which busy action is the cubit doing
  final AppointBranchBusyAction busyAction;

  /// Handles data pagination
  final Pagination pagination;

  /// Creates a new [AppointmentBranchState]
  AppointmentBranchState({
    Iterable<Branch> branches = const <Branch>[],
    this.error = AppointmentBranchStateError.none,
    this.errorMessage = '',
    this.busy = false,
    this.pagination = const Pagination(canLoadMore: false),
    this.busyAction = AppointBranchBusyAction.loading,
  }) : branches = UnmodifiableListView(branches);

  @override
  List<Object?> get props {
    return [
      branches,
      error,
      errorMessage,
      busy,
      pagination,
      busyAction,
    ];
  }

  /// Makes a copy of [AppointmentBranchState]
  AppointmentBranchState copyWith({
    Iterable<Branch>? branches,
    AppointmentBranchStateError? error,
    String? errorMessage,
    bool? busy,
    Pagination? pagination,
    AppointBranchBusyAction? busyAction,
  }) {
    return AppointmentBranchState(
      branches: branches ?? this.branches,
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      busy: busy ?? this.busy,
      pagination: pagination ?? this.pagination,
      busyAction: busyAction ?? this.busyAction,
    );
  }
}
