import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// Enum for all possible errors for [CardTransactionsCubit]
enum CardTransactionsStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Represents the state of [CardTransactionsCubit]
class CardTransactionsState extends Equatable {
  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// [Card] id which will be used by this cubit
  final String cardId;

  /// List of [CardTransactions] of the customer [Card]
  final UnmodifiableListView<CardTransaction> transactions;

  /// True if the cubit is processing something
  final bool busy;

  /// Error message for the last occurred error
  final CardTransactionsStateErrors error;

  /// Has all the data needed to handle the list of card transactions.
  final CardTransactionsListData listData;

  /// Creates a new instance of [CardTransactionsState]
  CardTransactionsState({
    required this.customerId,
    required this.cardId,
    Iterable<CardTransaction> transactions = const [],
    this.busy = false,
    this.error = CardTransactionsStateErrors.none,
    required this.listData,
  }) : transactions = UnmodifiableListView(transactions);

  @override
  List<Object?> get props => [
        customerId,
        cardId,
        transactions,
        busy,
        error,
        listData,
      ];

  /// Creates a new instance of [CardTransactionsState]
  /// based on the current instance
  CardTransactionsState copyWith({
    String? customerId,
    String? cardId,
    Iterable<CardTransaction>? transactions,
    bool? busy,
    CardTransactionsStateErrors? error,
    CardTransactionsListData? listData,
  }) =>
      CardTransactionsState(
        customerId: customerId ?? this.customerId,
        cardId: cardId ?? this.cardId,
        transactions: transactions ?? this.transactions,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        listData: listData ?? this.listData,
      );
}

/// Keeps all the data needed for filtering the customer
class CardTransactionsListData extends Equatable {
  /// Limit of items to load at a time.
  final int limit;

  /// The current offset for the loaded list.
  final int offset;

  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// Creates a new [CustomerListData] with the default values.
  const CardTransactionsListData({
    required this.limit,
    this.offset = 0,
    this.canLoadMore = false,
  });

  @override
  List<Object?> get props => [
        limit,
        offset,
        canLoadMore,
      ];

  /// Creates a new object based on this one.
  CardTransactionsListData copyWith({
    int? limit,
    int? offset,
    bool? canLoadMore,
  }) =>
      CardTransactionsListData(
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        canLoadMore: canLoadMore ?? this.canLoadMore,
      );
}
