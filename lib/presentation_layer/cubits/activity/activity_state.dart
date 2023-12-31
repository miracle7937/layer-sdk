import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../../utils.dart';

/// The available error status
enum ActivityErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// Which loading action the cubit is doing
enum ActivityBusyAction {
  /// nothing is happening
  none,

  /// if loading the first time
  loading,

  /// If is loading more data
  loadingMore,
}

/// The state for [ActivityCubit]
class ActivityState extends Equatable {
  /// The current error status.
  final ActivityErrorStatus errorStatus;

  /// Has all the data needed to handle the list of activities.
  final Pagination pagination;

  /// A list of activities
  final UnmodifiableListView<Activity> activities;

  /// Which busy action is the cubit doing
  final ActivityBusyAction action;

  /// The name for the shorcut activity action
  final String shortcutName;

  /// A String that holds an error message
  final String? errorMessage;

  /// Creates a new [ActivityState] instance
  ActivityState({
    Iterable<Activity> activities = const <Activity>[],
    this.action = ActivityBusyAction.none,
    this.errorStatus = ActivityErrorStatus.none,
    this.pagination = const Pagination(),
    this.shortcutName = '',
    this.errorMessage,
  }) : activities = UnmodifiableListView(activities);

  /// Copies the object with new values
  ActivityState copyWith({
    ActivityErrorStatus? errorStatus,
    ActivityBusyAction? action,
    Pagination? pagination,
    Iterable<Activity>? activities,
    String? shortcutName,
    String? errorMessage,
    Activity? alert,
  }) {
    return ActivityState(
      errorStatus: errorStatus ?? this.errorStatus,
      action: action ?? this.action,
      pagination: pagination ?? this.pagination,
      activities: activities ?? this.activities,
      shortcutName: shortcutName ?? this.shortcutName,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        errorStatus,
        action,
        pagination,
        activities,
        shortcutName,
        errorMessage,
      ];
}
