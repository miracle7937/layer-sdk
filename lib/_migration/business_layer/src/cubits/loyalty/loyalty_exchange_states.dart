import 'package:equatable/equatable.dart';
import '../../../../data_layer/data_layer.dart';

/// Handles LoyaltyExchange error status
enum LoyaltyExchangeErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Handles the success and second factor statuses
enum LoyaltyExchangeStatus {
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
class LoyaltyExchangeState extends Equatable {
  /// Loyalty exchange response
  final LoyaltyExchange loyaltyExchange;

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
  final LoyaltyExchangeErrorStatus errorStatus;

  /// True if the cubit is loading initial data
  final bool busy;

  /// True is the transaction is being processes
  final bool processing;

  /// The status of the current transaction
  ///
  /// When [LoyaltyExchangeStatus.none] the trasaction is not done yet
  final LoyaltyExchangeStatus status;

  /// The error returned from BE after a failed transaction
  final String? transactionError;

  /// Create a [LoyaltyExchangeState] object
  const LoyaltyExchangeState({
    this.rate = 0.0,
    this.points = 0,
    this.errorStatus = LoyaltyExchangeErrorStatus.none,
    this.busy = false,
    this.account,
    this.accounts = const [],
    this.card,
    this.cards = const [],
    this.currency,
    this.loyaltyExchange = const LoyaltyExchange(),
    this.processing = false,
    this.status = LoyaltyExchangeStatus.none,
    this.transactionError,
  });

  /// Wether the user has provided all the required information
  /// to submit the form or not.
  bool get canSubmit => (card != null || account != null) && points > 0;

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

  /// Clones [LoyaltyExchangeState]
  LoyaltyExchangeState copyWith({
    int? points,
    double? amount,
    Currency? currency,
    num? rate,
    Account? account,
    List<Account>? accounts,
    BankingCard? card,
    List<BankingCard>? cards,
    LoyaltyExchangeErrorStatus? errorStatus,
    bool? busy,
    LoyaltyExchange? loyaltyExchange,
    bool? processing,
    LoyaltyExchangeStatus? status,
    String? transactionError,
  }) {
    return LoyaltyExchangeState(
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
  }
}
