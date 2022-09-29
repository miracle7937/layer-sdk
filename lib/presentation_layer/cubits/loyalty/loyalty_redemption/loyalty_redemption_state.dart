import 'dart:collection';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum LoyaltyRedemptionAction {
  /// Loading currencies.
  currencies,

  /// Loading accounts.
  accounts,

  /// Loading all loyalty points.
  points,

  /// Loading all expired loyalty points.
  expiredPoints,

  /// Loading points rate.
  rate,

  /// Loading the base currency.
  baseCurrency,

  /// Exchanging of points.
  exchange,
}

/// The available events that the cubit can emit.
enum LoyaltyRedemptionEvent {
  /// Event for showing the confirmation view.
  showConfirmationView,

  /// Event for inputing the OTP code.
  inputOTPCode,

  /// Event for showing the transfer result view.
  showResultView,

  /// Event for closing the OTP code.
  closeOTPView,
}

/// The available validation error codes.
enum LoyaltyRedemptionValidationErrorCode {
  /// Invalid IBAN.
  invalidIBAN,

  /// Incorrect OTP code.
  incorrectOTPCode,

  /// Source account validation error.
  sourceAccountValidationError,

  /// Selected beneficiary validation error.
  selectedBeneficiaryValidationError,

  /// New beneficiary first name validation error.
  firstNameValidationError,

  /// New beneficiary last name validation error.
  lastNameValidationError,

  /// New beneficiary country validation error.
  countryValidationError,

  /// New beneficiary currency validation error.
  currencyValidationError,

  /// New beneficiary IBAN/Account number validation error.
  ibanOrAccountValidationError,

  /// New beneficiary routing code validation error.
  routingCodeValidationError,

  /// New beneficiary bank validation error.
  bankValidationError,

  /// New beneficiary amount validation error.
  amountValidationError,

  /// New beneficiary nickname validation error.
  nicknameValidationError,

  /// Shortcut name validation error.
  shortcutNameValidationError,

  /// Schedule details validation error.
  scheduleDetailsValidationError,

  /// Insufficient balance validation error.
  insufficientBalanceValidationError,
}

/// The state for the [LoyaltyRedemptionCubit].
class LoyaltyRedemptionState extends BaseState<LoyaltyRedemptionAction,
    LoyaltyRedemptionEvent, LoyaltyRedemptionValidationErrorCode> {
  /// All the currencies.
  final UnmodifiableListView<Currency> currencies;

  /// List of [Account]s.
  final UnmodifiableListView<Account> accounts;

  // /// Rate of exchange
  // final num rate;

  /// Loyalty points.
  final LoyaltyPoints loyaltyPoints;

  /// Base currency.
  final String baseCurrency;

  /// Creates a new [LoyaltyRedemptionState].
  LoyaltyRedemptionState({
    super.actions = const <LoyaltyRedemptionAction>{},
    super.errors = const <CubitError>{},
    super.events = const <LoyaltyRedemptionEvent>{},
    Iterable<Currency> currencies = const <Currency>{},
    Iterable<Account> accounts = const <Account>[],
    // this.rate = 0.0,
    this.loyaltyPoints = const LoyaltyPoints(id: -1),
    this.baseCurrency = '',
  })  : currencies = UnmodifiableListView(currencies),
        accounts = UnmodifiableListView(accounts);

  @override
  LoyaltyRedemptionState copyWith({
    Set<LoyaltyRedemptionAction>? actions,
    Set<CubitError>? errors,
    Set<LoyaltyRedemptionEvent>? events,
    Iterable<Currency>? currencies,
    Iterable<Account>? accounts,
    // num? rate,
    LoyaltyPoints? loyaltyPoints,
    String? baseCurrency,
  }) =>
      LoyaltyRedemptionState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        currencies: currencies ?? this.currencies,
        accounts: accounts ?? this.accounts,
        // rate: rate ?? this.rate,
        loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
        baseCurrency: baseCurrency ?? this.baseCurrency,
      );

  @override
  List<Object?> get props => [
        errors,
        actions,
        events,
        currencies,
        accounts,
        // rate,
        loyaltyPoints,
        baseCurrency,
      ];
}
