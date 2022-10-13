import 'dart:collection';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';

/// The available actions.
enum PayToMobileAction {
  /// Loading the accounts.
  accounts,

  /// Loading the currencies.
  currencies,

  /// Loading the countries.
  countries,
}

/// The available events.
enum PayToMobileEvent {
  /// Initialize flow.
  ///
  /// This event should be handled by the UI for initializing the UI components
  /// with the retrieved info from the API.
  initializeFlow,

  /// Clear shortcut name.
  clearShortcutName,

  /// Event for showing the confirmation view.
  showConfirmationView,
}

/// The available validation error codes.
enum PayToMobileValidationErrorCode {
  /// Source account validation error.
  sourceAccountValidationError,

  /// Dial code validation error.
  dialCodeValidationError,

  /// Phone number validation error.
  phoneNumberValidationError,

  /// Amount validation error.
  amountValidationError,

  /// Insufficient balance validation error.
  insufficientBalanceValidationError,

  /// Transaction code empty validation error.
  transactionCodeEmptyValidationError,

  /// Transaction code length validation error.
  transactionCodeLengthValidationError,

  /// Shortcut name validation error.
  shortcutNameValidationError,
}

/// The state for the [PayToMobileCubit].
class PayToMobileState extends BaseState<PayToMobileAction, PayToMobileEvent,
    PayToMobileValidationErrorCode> {
  /// The new pay to mobile object.
  final NewPayToMobile payToMobile;

  /// All the currencies.
  final UnmodifiableListView<Currency> currencies;

  /// All the countries.
  final UnmodifiableListView<Country> countries;

  /// List of source [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// Creates a new [PayToMobileState].
  PayToMobileState({
    required this.payToMobile,
    super.actions = const <PayToMobileAction>{},
    super.errors = const <CubitError>{},
    super.events = const <PayToMobileEvent>{},
    Iterable<Account> accounts = const <Account>[],
    Iterable<Currency> currencies = const <Currency>[],
    Iterable<Country> countries = const <Country>[],
  })  : accounts = UnmodifiableListView(accounts),
        currencies = UnmodifiableListView(currencies),
        countries = UnmodifiableListView(countries);

  @override
  PayToMobileState copyWith({
    NewPayToMobile? payToMobile,
    Set<PayToMobileAction>? actions,
    Set<CubitError>? errors,
    Set<PayToMobileEvent>? events,
    Iterable<Account>? accounts,
    Iterable<Currency>? currencies,
    Iterable<Country>? countries,
  }) =>
      PayToMobileState(
        payToMobile: payToMobile ?? this.payToMobile,
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        accounts: accounts ?? this.accounts,
        currencies: currencies ?? this.currencies,
        countries: countries ?? this.countries,
      );

  @override
  List<Object?> get props => [
        payToMobile,
        errors,
        actions,
        events,
        accounts,
        currencies,
        countries,
      ];
}
