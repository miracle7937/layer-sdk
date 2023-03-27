import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../cubits.dart';

/// The actions performed by the cubit
enum BeneficiaryDetailsAction {
  /// The beneficiary is being deleted
  delete,
}

/// The errors handled by the cubit
enum BeneficiaryDetailsError {
  /// No error occurred.
  none,

  /// A generic error occurred.
  generic,

  /// Error thrown when trying to delete a beneficiary that has a
  /// ongoing standing order.
  beneficiaryHasStandingOrder,
}

/// The state of the [BeneficiaryDetailsCubit].
class BeneficiaryDetailsState extends Equatable {
  /// The actions performed by the cubit.
  final UnmodifiableSetView<BeneficiaryDetailsAction> actions;

  /// The error that occurred when executing the last action.
  final BeneficiaryDetailsError error;

  /// Creates new [BeneficiaryDetailsState].
  BeneficiaryDetailsState({
    Set<BeneficiaryDetailsAction> actions = const {},
    this.error = BeneficiaryDetailsError.none,
  }) : actions = UnmodifiableSetView(actions);

  /// Creates a new state based on this one.
  BeneficiaryDetailsState copyWith({
    Set<BeneficiaryDetailsAction>? actions,
    BeneficiaryDetailsError? error,
  }) =>
      BeneficiaryDetailsState(
        actions: actions ?? this.actions,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        actions,
        error,
      ];
}
