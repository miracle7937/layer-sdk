import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

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

  /// The current error status.
  final EditBeneficiaryErrorStatus errorStatus;

  /// True if the cubit is processing something.
  final bool busy;

  /// Current action.
  final EditBeneficiaryAction action;

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
    this.errorStatus = EditBeneficiaryErrorStatus.none,
    this.busy = false,
    this.action = EditBeneficiaryAction.none,
  }) : countries = UnmodifiableListView(countries);

  @override
  List<Object?> get props => [
        oldBeneficiary,
        beneficiary,
        countries,
        errorStatus,
        busy,
        action,
      ];

  /// Creates a new state based on this one.
  EditBeneficiaryState copyWith({
    Beneficiary? beneficiary,
    Iterable<Country>? countries,
    EditBeneficiaryErrorStatus? errorStatus,
    bool? busy,
    EditBeneficiaryAction? action,
  }) =>
      EditBeneficiaryState(
        oldBeneficiary: oldBeneficiary,
        beneficiary: beneficiary ?? this.beneficiary,
        countries: countries ?? this.countries,
        errorStatus: errorStatus ?? this.errorStatus,
        busy: busy ?? this.busy,
        action: action ?? this.action,
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

  /// Edit successful beneficiary action.
  success,

  /// No action.
  none,
}
