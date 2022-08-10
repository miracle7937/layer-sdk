import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Enum that represents all actions that can be performed by
/// the [CustomerLimitsCubit].
enum CustomerLimitsAction {
  /// No action is being performed.
  none,

  /// The customer limits are being loaded.
  loadingLimits,
}

/// Enum that represents all errors that can be emitted by
/// the [CustomerLimitsCubit].
enum CustomerLimitsError {
  /// No error.
  none,

  /// The customer has no limits set.
  noLimitsSet,

  /// Generic error.
  generic,
}

/// Holds the state of the [CustomerLimitsCubit].
class CustomerLimitsState extends Equatable {
  /// The limits of the customer.
  final CustomerLimit? limit;

  /// The action being performed.
  final CustomerLimitsAction action;

  /// The latest error.
  final CustomerLimitsError error;

  /// Creates a new [CustomerLimitsState] instance.
  CustomerLimitsState({
    this.limit,
    this.action = CustomerLimitsAction.none,
    this.error = CustomerLimitsError.none,
  });

  /// Creates a copy of a [CustomerLimitsState] with the provided parameters.
  CustomerLimitsState copyWith({
    CustomerLimit? limit,
    CustomerLimitsAction? action,
    CustomerLimitsError? error,
  }) {
    return CustomerLimitsState(
      limit: limit ?? this.limit,
      action: action ?? this.action,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        limit,
        action,
        error,
      ];
}
