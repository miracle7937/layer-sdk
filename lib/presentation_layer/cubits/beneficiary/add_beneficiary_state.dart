import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// The available error status
enum AddBeneficiaryErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the AddBeneficiary cubit
class AddBeneficiaryState extends Equatable {
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

  /// The current error status.
  final AddBeneficiaryErrorStatus errorStatus;

  /// True if the cubit is processing something.
  final bool busy;

  /// Current action.
  final AddBeneficiaryAction action;

  ///
  bool get sortCodeRequired =>
      (selectedCurrency?.code?.toLowerCase() ?? '') == 'gbp';

  /// Creates a new [AddBeneficiaryState].
  AddBeneficiaryState({
    Iterable<Country> countries = const <Country>[],
    Iterable<Currency> availableCurrencies = const <Currency>[],
    Iterable<Bank> banks = const <Bank>[],
    this.selectedCurrency,
    this.selectedCountry,
    this.errorStatus = AddBeneficiaryErrorStatus.none,
    this.busy = false,
    this.action = AddBeneficiaryAction.none,
  })  : countries = UnmodifiableListView(countries),
        availableCurrencies = UnmodifiableListView(availableCurrencies),
        banks = UnmodifiableListView(banks);

  @override
  List<Object?> get props => [
        countries,
        availableCurrencies,
        banks,
        selectedCurrency,
        selectedCountry,
        errorStatus,
        busy,
        action,
      ];

  /// Creates a new state based on this one.
  AddBeneficiaryState copyWith({
    Iterable<Country>? countries,
    Iterable<Currency>? availableCurrencies,
    Iterable<Bank>? banks,
    Currency? selectedCurrency,
    Country? selectedCountry,
    AddBeneficiaryErrorStatus? errorStatus,
    bool? busy,
    AddBeneficiaryAction? action,
  }) =>
      AddBeneficiaryState(
        countries: countries ?? this.countries,
        availableCurrencies: availableCurrencies ?? this.availableCurrencies,
        banks: banks ?? this.banks,
        selectedCurrency: selectedCurrency ?? this.selectedCurrency,
        selectedCountry: selectedCountry ?? this.selectedCountry,
        errorStatus: errorStatus ?? this.errorStatus,
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

  /// No action.
  none,
}
