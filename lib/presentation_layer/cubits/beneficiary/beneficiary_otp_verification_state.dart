import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Model used for the errors.
class BeneficiaryOtpVerificationError extends Equatable {
  /// The action.
  final BeneficiaryOtpVerificationAction action;

  /// The error.
  final BeneficiaryOtpVerificationErrorStatus errorStatus;

  /// The error code.
  final String? code;

  /// The error message.
  final String? message;

  /// Creates a new [BeneficiaryOtpVerificationError].
  const BeneficiaryOtpVerificationError({
    required this.action,
    required this.errorStatus,
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [
        action,
        errorStatus,
        code,
        message,
      ];
}

/// The available error status
enum BeneficiaryOtpVerificationErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the [BeneficiaryOtpVerificationCubit]
class BeneficiaryOtpVerificationState extends Equatable {
  /// New beneficiary.
  final Beneficiary beneficiary;

  /// The errors.
  final UnmodifiableSetView<BeneficiaryOtpVerificationError> errors;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<BeneficiaryOtpVerificationAction> actions;

  /// Creates a new [BeneficiaryOtpVerificationState].
  BeneficiaryOtpVerificationState({
    required this.beneficiary,
    Set<BeneficiaryOtpVerificationAction> actions =
        const <BeneficiaryOtpVerificationAction>{},
    Set<BeneficiaryOtpVerificationError> errors =
        const <BeneficiaryOtpVerificationError>{},
  })  : actions = UnmodifiableSetView(actions),
        errors = UnmodifiableSetView(errors);

  @override
  List<Object?> get props => [
        beneficiary,
        errors,
        actions,
      ];

  /// Creates a new state based on this one.
  BeneficiaryOtpVerificationState copyWith({
    Beneficiary? beneficiary,
    Set<BeneficiaryOtpVerificationAction>? actions,
    Set<BeneficiaryOtpVerificationError>? errors,
  }) =>
      BeneficiaryOtpVerificationState(
        beneficiary: beneficiary ?? this.beneficiary,
        errors: errors ?? this.errors,
        actions: actions ?? this.actions,
      );
}

/// All possible actions.
enum BeneficiaryOtpVerificationAction {
  /// Verifying OTP action.
  verifyOtp,

  /// Resending OTP action.
  resendOtp,

  /// OTP verification successful.
  success,
}
