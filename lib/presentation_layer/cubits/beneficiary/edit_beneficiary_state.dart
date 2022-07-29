import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Model used for the errors.
class EditBeneficiaryError extends Equatable {
  /// The action.
  final EditBeneficiaryAction action;

  /// The error.
  final EditBeneficiaryErrorStatus errorStatus;

  /// The error code.
  final String? code;

  /// The error message.
  final String? message;

  /// Creates a new [EditBeneficiaryError].
  const EditBeneficiaryError({
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
enum EditBeneficiaryErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the EditBeneficiary cubit
class EditBeneficiaryState extends Equatable {
  /// Beneficiary to edit.
  final Beneficiary oldBeneficiary;

  /// New beneficiary.
  final Beneficiary beneficiary;

  /// A list of countries
  final UnmodifiableListView<Country> countries;

  /// The errors.
  final UnmodifiableSetView<EditBeneficiaryError> errors;

  /// True if the cubit is processing something.
  final bool busy;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<EditBeneficiaryAction> actions;

  /// Depending on its currency, beneficiary has:
  /// - for `GBP` - account and sorting code
  /// - for `EUR` - iban
  bool get hasAccount =>
      (oldBeneficiary.currency?.toLowerCase() ?? '') == 'gbp';

  /// Saving of new beneficiary is allowed,
  /// when all required fields are filled and some fields have changes.
  bool get saveAvailable =>
      (beneficiary.nickname.isNotEmpty) &&
      ((beneficiary.nickname != oldBeneficiary.nickname) ||
          (beneficiary.address1 != oldBeneficiary.address1) ||
          (beneficiary.address2 != oldBeneficiary.address2) ||
          (beneficiary.address3 != oldBeneficiary.address3));

  /// Creates a new [EditBeneficiaryState].
  EditBeneficiaryState({
    required this.oldBeneficiary,
    required this.beneficiary,
    Iterable<Country> countries = const <Country>[],
    Set<EditBeneficiaryAction> actions = const <EditBeneficiaryAction>{},
    Set<EditBeneficiaryError> errors = const <EditBeneficiaryError>{},
    this.busy = false,
  })  : countries = UnmodifiableListView(countries),
        actions = UnmodifiableSetView(actions),
        errors = UnmodifiableSetView(errors);

  @override
  List<Object?> get props => [
        oldBeneficiary,
        beneficiary,
        countries,
        errors,
        busy,
        actions,
      ];

  /// Creates a new state based on this one.
  EditBeneficiaryState copyWith({
    Beneficiary? beneficiary,
    Iterable<Country>? countries,
    Set<EditBeneficiaryAction>? actions,
    Set<EditBeneficiaryError>? errors,
    bool? busy,
    EditBeneficiaryAction? action,
  }) =>
      EditBeneficiaryState(
        oldBeneficiary: oldBeneficiary,
        beneficiary: beneficiary ?? this.beneficiary,
        countries: countries ?? this.countries,
        errors: errors ?? this.errors,
        busy: busy ?? this.busy,
        actions: actions ?? this.actions,
      );
}

/// All possible actions.
enum EditBeneficiaryAction {
  /// Init action, is used to set initial values.
  initAction,

  /// Editing action.
  editAction,

  /// Completion of process action.
  confirmCompletionAction,

  /// Saving of edited beneficiary action.
  save,

  /// Verifying OTP action.
  verifyOtp,

  /// Resending OTP action.
  resendOtp,

  /// Edit successful beneficiary action.
  success,

  /// No action.
  none,
}
