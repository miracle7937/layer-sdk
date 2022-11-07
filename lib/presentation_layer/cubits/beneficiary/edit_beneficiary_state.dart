import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// All possible actions.
enum EditBeneficiaryAction {
  /// Adding new beneficiary action.
  save,

  /// Sending the OTP code for the beneficiary.
  sendOTPCode,

  /// The second factor is being verified.
  verifySecondFactor,

  /// The second factor is being resent.
  resendSecondFactor,
}

/// The available add beneficiary cubit events.
enum EditBeneficiaryEvent {
  /// Event for opening the second factor.
  openSecondFactor,

  /// Event for showing the OTP code inputing view.
  showOTPCodeView,

  /// Event for closing the second factor.
  closeSecondFactor,

  /// Event for showing the beneficiary result view.
  showResultView,
}

/// The state of the EditBeneficiary cubit
class EditBeneficiaryState
    extends BaseState<EditBeneficiaryAction, EditBeneficiaryEvent, void> {
  /// Beneficiary to edit.
  final Beneficiary oldBeneficiary;

  /// New beneficiary.
  final Beneficiary beneficiary;

  /// The beneficiary that we got from the API.
  final Beneficiary? beneficiaryResult;

  /// A list of countries
  final UnmodifiableListView<Country> countries;

  /// Depending on its currency, beneficiary has:
  /// - for `GBP` - account and routing code
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
    super.actions = const <EditBeneficiaryAction>{},
    super.errors = const <CubitError>{},
    super.events = const <EditBeneficiaryEvent>{},
    required this.oldBeneficiary,
    required this.beneficiary,
    this.beneficiaryResult,
    Iterable<Country> countries = const <Country>[],
  }) : countries = UnmodifiableListView(countries);

  /// Creates a new state based on this one.
  EditBeneficiaryState copyWith({
    Set<EditBeneficiaryAction>? actions,
    Set<CubitError>? errors,
    Set<EditBeneficiaryEvent>? events,
    Beneficiary? beneficiary,
    Beneficiary? beneficiaryResult,
    Iterable<Country>? countries,
  }) =>
      EditBeneficiaryState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        oldBeneficiary: oldBeneficiary,
        beneficiary: beneficiary ?? this.beneficiary,
        beneficiaryResult: beneficiaryResult ?? this.beneficiaryResult,
        countries: countries ?? this.countries,
      );

  @override
  List<Object?> get props => [
        actions,
        errors,
        events,
        oldBeneficiary,
        beneficiary,
        beneficiaryResult,
        countries,
      ];
}
