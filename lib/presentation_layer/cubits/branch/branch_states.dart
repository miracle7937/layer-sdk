import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// All possible errors for [BranchState]
enum BranchStateError {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Describe what the cubit may be busy performing.
enum BranchBusyAction {
  /// Loading the branches.
  load,
}

/// The state of the branch cubit
class BranchState extends Equatable {
  /// A list of branches
  final UnmodifiableListView<Branch> branches;

  /// True if the cubit is processing something.
  /// This is calculated by what action is the cubit performing.
  final bool busy;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<BranchBusyAction> actions;

  /// The current error.
  final BranchStateError error;

  /// Creates a new [BranchState].
  BranchState({
    Iterable<Branch> branches = const <Branch>[],
    Set<BranchBusyAction> actions = const <BranchBusyAction>{},
    this.error = BranchStateError.none,
  })  : branches = UnmodifiableListView(branches),
        actions = UnmodifiableSetView(actions),
        busy = actions.isNotEmpty;

  @override
  List<Object?> get props => [
        branches,
        actions,
        busy,
        error,
      ];

  /// Creates a new state based on this one.
  BranchState copyWith({
    List<Branch>? branches,
    Set<BranchBusyAction>? actions,
    BranchStateError? error,
  }) =>
      BranchState(
        branches: branches ?? this.branches,
        actions: actions ?? this.actions,
        error: error ?? this.error,
      );
}
