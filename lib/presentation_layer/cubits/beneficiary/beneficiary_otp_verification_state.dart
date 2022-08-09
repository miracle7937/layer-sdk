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

  /// Incorrect OTP code.
  incorrectOTPCode,
}

/// The state of the [BeneficiaryOtpVerificationCubit]
class BeneficiaryOtpVerificationState extends Equatable {
  /// New beneficiary.
  final Beneficiary beneficiary;

  /// The errors.
  final UnmodifiableSetView<BeneficiaryOtpVerificationError> errors;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<BeneficiaryOtpVerificationAction> actions;

  /// Whether if the OTP was verified.
  final bool isVerified;

  /// Creates a new [BeneficiaryOtpVerificationState].
  BeneficiaryOtpVerificationState({
    required this.beneficiary,
    Set<BeneficiaryOtpVerificationAction> actions =
        const <BeneficiaryOtpVerificationAction>{},
    Set<BeneficiaryOtpVerificationError> errors =
        const <BeneficiaryOtpVerificationError>{},
    this.isVerified = false,
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
    bool? isVerified,
  }) =>
      BeneficiaryOtpVerificationState(
        beneficiary: beneficiary ?? this.beneficiary,
        errors: errors ?? this.errors,
        actions: actions ?? this.actions,
        isVerified: isVerified ?? this.isVerified,
      );
}

/// All possible actions.
enum BeneficiaryOtpVerificationAction {
  /// Verifying OTP action.
  verifyOtp,

  /// Resending OTP action.
  resendOtp,
}
