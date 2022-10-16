import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';

/// Handles LoyaltyExchange error status
enum LoyaltyPointsExchangeErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Handles the success and second factor statuses
enum LoyaltyPointsExchangeStatus {
  /// Transaction completed
  completed,

  /// OTP required
  otp,

  /// Transaction pin required
  pin,

  /// Hardware token is required
  hardwareToken,

  /// An error occured during the transaction
  error,

  /// Transaction not done yet
  none,
}

/// LoyaltyExchange
/// TODO: Change the accounts to use the new structure.
/// TODO: Change the cards to use the new strucutre.
class LoyaltyPointsExchangeState extends Equatable {
  /// Loyalty exchange response
  final LoyaltyPointsExchange loyaltyExchange;

  /// Amount of loyalty points
  final int points;

  /// Currency displayed
  final Currency? currency;

  /// Rate of exchange
  final num rate;

  /// Account number that will receive the exchanged points
  final Account? account;

  /// List of accounts the user can select from
  final List<Account> accounts;

  /// Card id that will receive the exchanged points
  final BankingCard? card;

  /// List of cards the user can select from
  final List<BankingCard> cards;

  /// Status of the the exchange
  final LoyaltyPointsExchangeErrorStatus errorStatus;

  /// True if the cubit is loading initial data
  final bool busy;

  /// True is the transaction is being processes
  final bool processing;

  /// The status of the current transaction
  ///
  /// When [LoyaltyPointsExchangeStatus.none] the trasaction is not done yet
  final LoyaltyPointsExchangeStatus status;

  /// The error returned from BE after a failed transaction
  final String? transactionError;

  /// Create a [LoyaltyPointsExchangeState] object
  const LoyaltyPointsExchangeState({
    this.rate = 0.0,
    this.points = 0,
    this.errorStatus = LoyaltyPointsExchangeErrorStatus.none,
    this.busy = false,
    this.account,
    this.accounts = const [],
    this.card,
    this.cards = const [],
    this.currency,
    this.loyaltyExchange = const LoyaltyPointsExchange(),
    this.processing = false,
    this.status = LoyaltyPointsExchangeStatus.none,
    this.transactionError,
  });

  /// Wether the user has provided all the required information
  /// to submit the form or not.
  bool get canSubmit => /*(card != null || account != null) &&*/ points > 0;

  /// Clones [LoyaltyPointsExchangeState]
  LoyaltyPointsExchangeState copyWith({
    int? points,
    double? amount,
    Currency? currency,
    num? rate,
    Account? account,
    List<Account>? accounts,
    BankingCard? card,
    List<BankingCard>? cards,
    LoyaltyPointsExchangeErrorStatus? errorStatus,
    bool? busy,
    LoyaltyPointsExchange? loyaltyExchange,
    bool? processing,
    LoyaltyPointsExchangeStatus? status,
    String? transactionError,
  }) =>
      LoyaltyPointsExchangeState(
        points: points ?? this.points,
        currency: currency ?? this.currency,
        rate: rate ?? this.rate,
        account: account ?? this.account,
        accounts: accounts ?? this.accounts,
        card: card ?? this.card,
        cards: cards ?? this.cards,
        errorStatus: errorStatus ?? this.errorStatus,
        busy: busy ?? this.busy,
        loyaltyExchange: loyaltyExchange ?? this.loyaltyExchange,
        processing: processing ?? this.processing,
        status: status ?? this.status,
        transactionError: transactionError ?? this.transactionError,
      );

  @override
  List<Object?> get props => [
        points,
        currency,
        rate,
        errorStatus,
        account,
        accounts,
        card,
        cards,
        busy,
        loyaltyExchange,
        processing,
        status,
        transactionError,
      ];
}
