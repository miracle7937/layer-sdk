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

  /// Submitting the new pay to mobile.
  submit,

  /// Sending the OTP code for the pay to mobile.
  sendOTPCode,

  /// The second factor is being verified.
  verifySecondFactor,

  /// The second factor is being resent.
  resendSecondFactor,

  /// The shortcut is being created.
  shortcut,
}

/// The available events.
enum PayToMobileEvent {
  /// Initialize flow.
  initializeFlow,

  /// Clear shortcut name.
  clearShortcutName,

  /// Event for showing the confirmation view.
  showConfirmationView,

  /// Event for opening the second factor.
  openSecondFactor,

  /// Event for showing the OTP code inputing view.
  showOTPCodeView,

  /// Event for closing the second factor.
  closeSecondFactor,

  /// Event for showing the transfer result view.
  showResultView,
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

  /// The pay to mobile result.
  final PayToMobile? payToMobileResult;

  /// Creates a new [PayToMobileState].
  PayToMobileState({
    required this.payToMobile,
    super.actions = const <PayToMobileAction>{},
    super.errors = const <CubitError>{},
    super.events = const <PayToMobileEvent>{},
    Iterable<Account> accounts = const <Account>[],
    Iterable<Currency> currencies = const <Currency>[],
    Iterable<Country> countries = const <Country>[],
    this.payToMobileResult,
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
    PayToMobile? payToMobileResult,
  }) =>
      PayToMobileState(
        payToMobile: payToMobile ?? this.payToMobile,
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        accounts: accounts ?? this.accounts,
        currencies: currencies ?? this.currencies,
        countries: countries ?? this.countries,
        payToMobileResult: payToMobileResult ?? this.payToMobileResult,
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
        payToMobileResult,
      ];
}
