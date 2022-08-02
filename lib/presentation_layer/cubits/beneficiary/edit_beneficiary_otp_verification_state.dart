import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Model used for the errors.
class EditBeneficiaryOtpVerificationError extends Equatable {
  /// The action.
  final EditBeneficiaryOtpVerificationAction action;

  /// The error.
  final EditBeneficiaryOtpVerificationErrorStatus errorStatus;

  /// The error code.
  final String? code;

  /// The error message.
  final String? message;

  /// Creates a new [EditBeneficiaryOtpVerificationError].
  const EditBeneficiaryOtpVerificationError({
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
enum EditBeneficiaryOtpVerificationErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the [EditBeneficiaryOtpVerificationCubit]
class EditBeneficiaryOtpVerificationState extends Equatable {
  /// New beneficiary.
  final Beneficiary beneficiary;

  /// The errors.
  final UnmodifiableSetView<EditBeneficiaryOtpVerificationError> errors;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<EditBeneficiaryOtpVerificationAction> actions;

  /// Creates a new [EditBeneficiaryOtpVerificationState].
  EditBeneficiaryOtpVerificationState({
    required this.beneficiary,
    Set<EditBeneficiaryOtpVerificationAction> actions =
        const <EditBeneficiaryOtpVerificationAction>{},
    Set<EditBeneficiaryOtpVerificationError> errors =
        const <EditBeneficiaryOtpVerificationError>{},
  })  : actions = UnmodifiableSetView(actions),
        errors = UnmodifiableSetView(errors);

  @override
  List<Object?> get props => [
        beneficiary,
        errors,
        actions,
      ];

  /// Creates a new state based on this one.
  EditBeneficiaryOtpVerificationState copyWith({
    Beneficiary? beneficiary,
    Set<EditBeneficiaryOtpVerificationAction>? actions,
    Set<EditBeneficiaryOtpVerificationError>? errors,
  }) =>
      EditBeneficiaryOtpVerificationState(
        beneficiary: beneficiary ?? this.beneficiary,
        errors: errors ?? this.errors,
        actions: actions ?? this.actions,
      );
}

/// All possible actions.
enum EditBeneficiaryOtpVerificationAction {
  /// Verifying OTP action.
  verifyOtp,

  /// Resending OTP action.
  resendOtp,

  /// OTP verification successful.
  success,
}
