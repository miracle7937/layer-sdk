import 'dart:collection';

import '../../../domain_layer/models.dart';
import '../../../layer_sdk.dart';
import '../../cubits.dart';

/// TODO: cubit_issue | Some of this actions are being used as flags for the UI
/// to perform steps. This is not how states should be used.
/// This can be achieved using [BlocListener]s on the UI.
///
/// All possible actions.
enum AddBeneficiaryAction {
  /// Initializing the cubit with the needed data.
  initialize,

  /// Adding new beneficiary action.
  add,

  /// Loading the banks for the new beneficiary.
  banks,

  /// Sending the OTP code for the beneficiary.
  sendOTPCode,

  /// The second factor is being verified.
  verifySecondFactor,

  /// The second factor is being resent.
  resendSecondFactor,
}

/// The available add beneficiary cubit events.
enum AddBeneficiaryEvent {
  /// Event for opening the second factor.
  openSecondFactor,

  /// Event for showing the OTP code inputing view.
  showOTPCodeView,

  /// Event for closing the second factor.
  closeSecondFactor,

  /// Event for showing the beneficiary result view.
  showResultView,
}

/// The available validation error codes.
enum AddBeneficiaryValidationErrorCode {
  /// Invalid IBAN.
  invalidIBAN,

  /// Invalid account.
  invalidAccount,
}

/// The state of the AddBeneficiary cubit
class AddBeneficiaryState extends BaseState<AddBeneficiaryAction,
    AddBeneficiaryEvent, AddBeneficiaryValidationErrorCode> {
  /// Beneficiary type
  final TransferType? beneficiaryType;

  /// New beneficiary.
  final Beneficiary? beneficiary;

  /// The beneficiary that we got from the API.
  final Beneficiary? beneficiaryResult;

  /// A list of countries
  final UnmodifiableListView<Country> countries;

  /// A list of available [Currency]s.
  final UnmodifiableListView<Currency> availableCurrencies;

  /// A list of [Bank]s.
  final UnmodifiableListView<Bank> banks;

  /// Has all the data needed to handle the list of activities.
  final Pagination banksPagination;

  /// TODO: cubit_issue | Don't we have the selectedCurrency and selectedCountry
  /// available inside the beneficiary object? Why do we need it also in the
  /// state as standalone parameters?
  ///
  /// Selected currency.
  final Currency? selectedCurrency;

  /// Selected country.
  final Country? selectedCountry;

  /// The beneficiary settings.
  final UnmodifiableListView<GlobalSetting> beneficiarySettings;

  /// Depending on selected country we display either an input for iban or
  /// account number and sort code.
  bool get accountRequired => !(selectedCountry?.isIBAN ?? false);

  /// TODO: cubit_issue | Not very descriptive. Could we change this to
  /// `canSubmit`for example?
  /// Adding of new beneficiary is allowed when all required fields are filled.
  bool get addAvailable =>
      (beneficiary?.firstName.isNotEmpty ?? false) &&
      (beneficiary?.nickname.isNotEmpty ?? false) &&
      (accountRequired &&
              (beneficiary?.accountNumber?.isNotEmpty != null) &&
              (beneficiary?.routingCode?.isNotEmpty != null) ||
          !accountRequired && (beneficiary?.iban?.isNotEmpty != null)) &&
      beneficiary?.recipientType != null;

  /// The bank query for filtering the banks.
  final String? bankQuery;

  /// Creates a new [AddBeneficiaryState].
  AddBeneficiaryState({
    super.actions = const <AddBeneficiaryAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AddBeneficiaryEvent>{},
    this.beneficiaryType,
    this.beneficiary,
    this.beneficiaryResult,
    Iterable<Country> countries = const <Country>[],
    Iterable<Currency> availableCurrencies = const <Currency>[],
    Iterable<Bank> banks = const <Bank>[],
    this.banksPagination = const Pagination(),
    this.selectedCurrency,
    this.selectedCountry,
    Iterable<GlobalSetting> beneficiarySettings = const <GlobalSetting>{},
    this.bankQuery,
    List<int> pdfBytes = const [],
    List<int> imageBytes = const [],
  })  : countries = UnmodifiableListView(countries),
        availableCurrencies = UnmodifiableListView(availableCurrencies),
        banks = UnmodifiableListView(banks),
        beneficiarySettings = UnmodifiableListView(beneficiarySettings);

  /// Creates a new state based on this one.
  AddBeneficiaryState copyWith({
    Set<AddBeneficiaryAction>? actions,
    Set<CubitError>? errors,
    Set<AddBeneficiaryEvent>? events,
    TransferType? beneficiaryType,
    Beneficiary? beneficiary,
    Beneficiary? beneficiaryResult,
    Iterable<Country>? countries,
    Iterable<Currency>? availableCurrencies,
    Iterable<Bank>? banks,
    Pagination? banksPagination,
    Currency? selectedCurrency,
    Country? selectedCountry,
    Iterable<GlobalSetting>? beneficiarySettings,
    String? bankQuery,
  }) =>
      AddBeneficiaryState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        beneficiaryType: beneficiaryType ?? this.beneficiaryType,
        beneficiary: beneficiary ?? this.beneficiary,
        beneficiaryResult: beneficiaryResult ?? this.beneficiaryResult,
        countries: countries ?? this.countries,
        availableCurrencies: availableCurrencies ?? this.availableCurrencies,
        banks: banks ?? this.banks,
        banksPagination: banksPagination ?? this.banksPagination,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        beneficiarySettings: beneficiarySettings ?? this.beneficiarySettings,
        bankQuery: bankQuery ?? this.bankQuery,
      );

  @override
  List<Object?> get props => [
        actions,
        errors,
        events,
        beneficiaryType,
        beneficiary,
        beneficiaryResult,
        countries,
        availableCurrencies,
        banks,
        banksPagination,
        selectedCurrency,
        selectedCountry,
        beneficiarySettings,
        bankQuery,
      ];
}
