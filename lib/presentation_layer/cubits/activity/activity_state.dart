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

  /// A list of [ActivityType]s
  final UnmodifiableListView<ActivityType> types;

  /// A list of [ActivityTag]s
  final UnmodifiableListView<ActivityTag> activityTags;

  /// A list of [TransferType]s
  final UnmodifiableListView<TransferType> transferTypes;

  /// Which busy action is the cubit doing
  final ActivityBusyAction action;

  /// Creates a new [ActivityState] instance
  ActivityState({
    Iterable<Activity> activities = const <Activity>[],
    Iterable<ActivityType> types = const <ActivityType>[],
    Iterable<ActivityTag> activityTags = const <ActivityTag>[],
    Iterable<TransferType> transferTypes = const <TransferType>[],
    this.action = ActivityBusyAction.none,
    this.errorStatus = ActivityErrorStatus.none,
    this.pagination = const Pagination(),
  })  : activities = UnmodifiableListView(activities),
        types = UnmodifiableListView(types),
        activityTags = UnmodifiableListView(activityTags),
        transferTypes = UnmodifiableListView(transferTypes);

  /// Copies the object with new values
  ActivityState copyWith({
    ActivityErrorStatus? errorStatus,
    ActivityBusyAction? action,
    Pagination? pagination,
    int? offSet,
    Iterable<Activity>? activities,
    Iterable<ActivityType>? types,
    Iterable<ActivityTag>? activityTags,
    Iterable<TransferType>? transferTypes,
  }) {
    return ActivityState(
      errorStatus: errorStatus ?? this.errorStatus,
      action: action ?? this.action,
      pagination: pagination ?? this.pagination,
      activities: activities ?? this.activities,
      types: types ?? this.types,
      activityTags: activityTags ?? this.activityTags,
      transferTypes: transferTypes ?? this.transferTypes,
    );
  }

  @override
  List<Object?> get props => [
        errorStatus,
        action,
        pagination,
        activities,
        types,
        activityTags,
        transferTypes,
      ];
}
