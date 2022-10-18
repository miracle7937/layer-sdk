import 'package:collection/collection.dart';

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
  /// Event for showing the result view.
  showResultView,
}

/// The state for the [LoyaltyRedemptionCubit].
class LoyaltyRedemptionState
    extends BaseState<LoyaltyRedemptionAction, LoyaltyRedemptionEvent, void> {
  /// All the currencies.
  final UnmodifiableListView<Currency> currencies;

  /// List of [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// Points converted to cash.
  double get cash => loyaltyPoints.balance / loyaltyPoints.rate;

  /// Loyalty points.
  final LoyaltyPoints loyaltyPoints;

  /// Base currency code.
  final String baseCurrencyCode;

  /// Exchange result.
  final LoyaltyPointsExchange? exchangeResult;

  /// If selected points can be exchanged.
  bool get canExchange => loyaltyPoints.balance > 0 && loyaltyPoints.rate > 0;

  /// Base currency.
  Currency? get baseCurrency =>
      baseCurrencyCode.isNotEmpty && currencies.isNotEmpty
          ? currencies.firstWhereOrNull(
              (currencyCode) => currencyCode.code == baseCurrencyCode,
            )
          : null;

  /// Creates a new [LoyaltyRedemptionState].
  LoyaltyRedemptionState({
    super.actions = const <LoyaltyRedemptionAction>{},
    super.errors = const <CubitError>{},
    super.events = const <LoyaltyRedemptionEvent>{},
    Iterable<Currency> currencies = const <Currency>{},
    Iterable<Account> accounts = const <Account>[],
    this.loyaltyPoints = const LoyaltyPoints(id: -1),
    this.baseCurrencyCode = '',
    this.exchangeResult,
  })  : currencies = UnmodifiableListView(currencies),
        accounts = UnmodifiableListView(accounts);

  @override
  LoyaltyRedemptionState copyWith({
    Set<LoyaltyRedemptionAction>? actions,
    Set<CubitError>? errors,
    Set<LoyaltyRedemptionEvent>? events,
    Iterable<Currency>? currencies,
    Iterable<Account>? accounts,
    LoyaltyPoints? loyaltyPoints,
    String? baseCurrencyCode,
    LoyaltyPointsExchange? exchangeResult,
  }) =>
      LoyaltyRedemptionState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        currencies: currencies ?? this.currencies,
        accounts: accounts ?? this.accounts,
        loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
        baseCurrencyCode: baseCurrencyCode ?? this.baseCurrencyCode,
        exchangeResult: exchangeResult ?? this.exchangeResult,
      );

  @override
  List<Object?> get props => [
        errors,
        actions,
        events,
        currencies,
        accounts,
        loyaltyPoints,
        baseCurrencyCode,
        exchangeResult,
      ];
}
