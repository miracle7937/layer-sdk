import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Model used for the errors.
class AddBeneficiaryError extends Equatable {
  /// The action.
  final AddBeneficiaryAction action;

  /// The error.
  final AddBeneficiaryErrorStatus errorStatus;

  /// The error code.
  final String? code;

  /// The error message.
  final String? message;

  /// Creates a new [AddBeneficiaryError].
  const AddBeneficiaryError({
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
enum AddBeneficiaryErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,

  /// Invalid account number.
  invalidAccount,

  /// Invalid IBAN.
  invalidIBAN,
}

/// The state of the AddBeneficiary cubit
class AddBeneficiaryState extends Equatable {
  /// Beneficiary type
  final TransferType? beneficiaryType;

  /// New beneficiary.
  final Beneficiary? beneficiary;

  /// A list of countries
  final UnmodifiableListView<Country> countries;

  /// A list of available [Currency]s.
  final UnmodifiableListView<Currency> availableCurrencies;

  /// A list of [Bank]s.
  final UnmodifiableListView<Bank> banks;

  /// Selected currency.
  final Currency? selectedCurrency;

  /// Selected country.
  final Country? selectedCountry;

  /// The errors.
  final UnmodifiableSetView<AddBeneficiaryError> errors;

  /// The beneficiary settings.
  final UnmodifiableListView<GlobalSetting> beneficiarySettings;

  /// True if the cubit is processing something.
  final bool busy;

  /// Current action.
  final AddBeneficiaryAction action;

  /// Depending on selected currency we force user to enter:
  /// - for `GBP` - account and sorting code
  /// - for `EUR` - iban
  bool get accountRequired =>
      (selectedCurrency?.code?.toLowerCase() ?? '') == 'gbp';

  /// Adding of new beneficiary is allowed when all required fields are filled.
  bool get addAvailable =>
      (beneficiary?.firstName.isNotEmpty ?? false) &&
      (beneficiary?.lastName.isNotEmpty ?? false) &&
      (beneficiary?.nickname.isNotEmpty ?? false) &&
      (beneficiary?.currency?.isNotEmpty != null) &&
      (accountRequired &&
              (beneficiary?.accountNumber?.isNotEmpty != null) &&
              (beneficiary?.routingCode?.isNotEmpty != null) ||
          !accountRequired && (beneficiary?.iban?.isNotEmpty != null)) &&
      (beneficiary?.bank != null);

  /// Creates a new [AddBeneficiaryState].
  AddBeneficiaryState({
    this.beneficiaryType,
    this.beneficiary,
    Iterable<Country> countries = const <Country>[],
    Iterable<Currency> availableCurrencies = const <Currency>[],
    Iterable<Bank> banks = const <Bank>[],
    this.selectedCurrency,
    this.selectedCountry,
    Set<AddBeneficiaryError> errors = const <AddBeneficiaryError>{},
    Iterable<GlobalSetting> beneficiarySettings = const <GlobalSetting>{},
    this.busy = false,
    this.action = AddBeneficiaryAction.none,
  })  : countries = UnmodifiableListView(countries),
        availableCurrencies = UnmodifiableListView(availableCurrencies),
        banks = UnmodifiableListView(banks),
        errors = UnmodifiableSetView(errors),
        beneficiarySettings = UnmodifiableListView(beneficiarySettings);

  @override
  List<Object?> get props => [
        beneficiaryType,
        beneficiary,
        countries,
        availableCurrencies,
        banks,
        selectedCurrency,
        selectedCountry,
        errors,
        beneficiarySettings,
        busy,
        action,
      ];

  /// Creates a new state based on this one.
  AddBeneficiaryState copyWith({
    Beneficiary? beneficiary,
    Iterable<Country>? countries,
    Iterable<Currency>? availableCurrencies,
    Iterable<Bank>? banks,
    Currency? selectedCurrency,
    Country? selectedCountry,
    Set<AddBeneficiaryError>? errors,
    Iterable<GlobalSetting>? beneficiarySettings,
    bool? busy,
    AddBeneficiaryAction? action,
  }) =>
      AddBeneficiaryState(
        beneficiaryType: beneficiaryType,
        beneficiary: beneficiary ?? this.beneficiary,
        countries: countries ?? this.countries,
        availableCurrencies: availableCurrencies ?? this.availableCurrencies,
        banks: banks ?? this.banks,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        errors: errors ?? this.errors,
        beneficiarySettings: beneficiarySettings ?? this.beneficiarySettings,
        busy: busy ?? this.busy,
        action: action ?? this.action,
      );
}

/// All possible actions.
enum AddBeneficiaryAction {
  /// Init action, is used to set initial values.
  initAction,

  /// Editing action.
  editAction,

  /// Completion of process action.
  confirmCompletionAction,

  /// Adding new beneficiary action.
  add,

  /// Adding new beneficiary requires OTP verification action.
  otpRequired,

  /// Successful adding new beneficiary action.
  success,

  /// No action.
  none,
}
