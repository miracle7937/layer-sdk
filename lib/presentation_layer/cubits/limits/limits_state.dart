import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

///The state of the limits cubit
class LimitsState extends Equatable {
  /// [Customer] id which will be used by this cubit
  final String? customerId;

  /// [Agent] id which will be used by this cubit
  final String? agentId;

  /// [Customer] type which will be used by this cubit
  final CustomerType customerType;

  /// Limits.
  final Limits? limits;

  /// Action type performed by cubit.
  final LimitsBusyAction busyAction;

  /// True when cubits performs an operation.
  bool get busy => busyAction != LimitsBusyAction.none;

  /// The current error status.
  final LimitsStateError error;

  /// Creates [LimitsState].
  LimitsState({
    this.customerId,
    this.agentId,
    required this.customerType,
    this.limits,
    this.busyAction = LimitsBusyAction.none,
    this.error = LimitsStateError.none,
  });

  /// Returns a new [LimitsState] modified by provided values.
  LimitsState copyWith({
    String? customerId,
    String? agentId,
    CustomerType? customerType,
    Limits? limits,
    LimitsBusyAction? busyAction,
    LimitsStateError? error,
  }) =>
      LimitsState(
        customerId: customerId ?? this.customerId,
        agentId: agentId ?? this.agentId,
        customerType: customerType ?? this.customerType,
        limits: limits ?? this.limits,
        busyAction: busyAction ?? this.busyAction,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        customerId,
        agentId,
        customerType,
        limits,
        busyAction,
        error,
      ];
}

/// An enum that defines possible error states
/// for the [LimitsState]
enum LimitsStateError {
  /// There is no error.
  none,

  /// A generic error happened.
  generic,
}

/// Describe what the cubit may be busy performing.
enum LimitsBusyAction {
  /// Loading the limits.
  load,

  /// Requesting lock.
  save,

  /// There is no action.
  none,
}
