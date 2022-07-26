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

/// The state for [ActivityCubit]
class ActivityState extends Equatable {
  /// True if the cubit is processing something.
  final bool busy;

  /// The current error status.
  final ActivityErrorStatus errorStatus;

  /// Has all the data needed to handle the list of activities.
  final Pagination pagination;

  /// Use to paginate the activities
  final int offSet;

  /// A list of activities
  final UnmodifiableListView<Activity> activities;

  /// Creates a new [ActivityState] instance
  ActivityState({
    Iterable<Activity> activities = const <Activity>[],
    this.busy = false,
    this.errorStatus = ActivityErrorStatus.none,
    this.pagination = const Pagination(),
    this.offSet = 0,
  }) : activities = UnmodifiableListView(activities);

  /// Copies the object with new values
  ActivityState copyWith({
    bool? busy,
    ActivityErrorStatus? errorStatus,
    Pagination? pagination,
    int? offSet,
    Iterable<Activity>? activities,
  }) {
    return ActivityState(
      busy: busy ?? this.busy,
      errorStatus: errorStatus ?? this.errorStatus,
      pagination: pagination ?? this.pagination,
      offSet: offSet ?? this.offSet,
      activities: activities ?? this.activities,
    );
  }

  @override
  List<Object?> get props => [
        busy,
        errorStatus,
        pagination,
        activities,
      ];
}
