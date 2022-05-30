import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// Represents the state of [AccountTransactionsCubit]
class AccountTransactionsState extends Equatable {
  /// True if the cubit is processing something
  final bool busy;

  /// List of [AccountTransactions] of the customer [Account]
  final UnmodifiableListView<AccountTransaction> transactions;

  /// Error message for the last occurred error
  final AccountTransactionsStateErrors error;

  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// [Account] id which will be used by this cubit
  final String accountId;

  /// Has all the data needed to handle the list of [BankingCard].
  final AccountTransactionsListData listData;

  /// Creates a new instance of [AccountTransactionsState]
  AccountTransactionsState({
    required this.customerId,
    required this.accountId,
    Iterable<AccountTransaction> transactions = const [],
    this.busy = false,
    this.error = AccountTransactionsStateErrors.none,
    this.listData = const AccountTransactionsListData(),
  }) : transactions = UnmodifiableListView(transactions);

  @override
  List<Object?> get props => [
        busy,
        transactions,
        error,
        customerId,
        accountId,
        listData,
      ];

  /// Creates a new instance of [AccountTransactionsState]
  /// based on the current instance
  AccountTransactionsState copyWith({
    bool? busy,
    Iterable<AccountTransaction>? transactions,
    AccountTransactionsStateErrors? error,
    String? accountId,
    String? customerId,
    AccountTransactionsListData? listData,
  }) {
    return AccountTransactionsState(
      busy: busy ?? this.busy,
      transactions: transactions ?? this.transactions,
      error: error ?? this.error,
      customerId: customerId ?? this.customerId,
      accountId: accountId ?? this.accountId,
      listData: listData ?? this.listData,
    );
  }

  @override
  bool get stringify => true;
}

/// Enum for all possible errors for [AccountTransactionsCubit]
enum AccountTransactionsStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Keeps all the pagination data for [BankingCard]
class AccountTransactionsListData extends Equatable {
  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// The current offset for the loaded list.
  final int offset;

  /// Creates a new [CustomerListData] with the default values.
  const AccountTransactionsListData({
    this.canLoadMore = false,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [
        canLoadMore,
        offset,
      ];

  /// Creates a new object based on this one.
  AccountTransactionsListData copyWith({
    bool? canLoadMore,
    int? offset,
  }) =>
      AccountTransactionsListData(
        canLoadMore: canLoadMore ?? this.canLoadMore,
        offset: offset ?? this.offset,
      );

  @override
  bool get stringify => true;
}
