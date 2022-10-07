import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import 'base_cubit/base_state.dart';

/// enum for error codes
enum BankingProductTransactionsErrorCode {
  /// loading error
  loadError,

  /// filter error
  filterError,

  /// receipt
  receipt
}

/// Represents the state of [BankingProductTransactionsCubit]
class BankingProductTransactionsState extends BaseState<
    BankingProductTransactionsAction,
    void,
    BankingProductTransactionsErrorCode> {
  /// List of [BankingProductTransactions] of the customer [BankingProduct]
  final List<BankingProductTransaction>? transactions;

  /// [BankingProduct] id which will be used by this cubit
  final String? accountId;

  /// [BankingProduct] id which will be used by this cubit
  final String? cardId;

  /// Has all the data needed to handle the list of [BankingCard].
  final BankingProductTransactionsListData listData;

  ///
  final DateTime? startDate;

  ///
  final DateTime? endDate;

  ///
  final double? amountFrom;

  ///
  final double? amountTo;

  ///
  final bool? credit;

  ///
  final List<int>? receipt;

  /// Creates a new instance of [BankingProductTransactionsState]
  BankingProductTransactionsState({
    this.accountId,
    this.cardId,
    this.transactions,
    this.startDate,
    super.actions = const <BankingProductTransactionsAction>{},
    super.errors = const <CubitError>{},
    this.endDate,
    this.amountFrom,
    this.amountTo,
    this.credit,
    this.receipt,
    this.listData = const BankingProductTransactionsListData(),
  });

  @override
  List<Object?> get props => [
        transactions,
        accountId,
        cardId,
        listData,
        startDate,
        endDate,
        amountFrom,
        amountTo,
        credit,
        receipt,
      ];

  /// Creates a new instance of [BankingProductTransactionsState]
  /// based on the current instance
  BankingProductTransactionsState copyWith({
    List<BankingProductTransaction>? transactions,
    Set<BankingProductTransactionsAction>? actions,
    Set<CubitError>? errors,
    String? accountId,
    String? cardId,
    BankingProductTransactionsListData? listData,
    DateTime? startDate,
    DateTime? endDate,
    double? amountFrom,
    double? amountTo,
    bool? credit,
    List<int>? receipt,
  }) {
    return BankingProductTransactionsState(
      transactions: transactions ?? this.transactions,
      actions: actions ?? super.actions,
      errors: errors ?? super.errors,
      accountId: accountId ?? this.accountId,
      cardId: cardId ?? this.cardId,
      listData: listData ?? this.listData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      amountFrom: amountFrom ?? this.amountFrom,
      amountTo: amountTo ?? this.amountTo,
      credit: credit ?? this.credit,
      receipt: receipt ?? this.receipt,
    );
  }

  @override
  bool get stringify => true;
}

/// Enum for possible actions
enum BankingProductTransactionsAction {
  /// Loading the balances
  loadInitialTransactions,

  /// Changing the date
  filtering,

  /// Loading More once limit reached
  loadingMore,

  /// Getting the receipt
  receipt,
}

/// Keeps all the pagination data for [BankingCard]
class BankingProductTransactionsListData extends Equatable {
  /// If there is more data to be loaded.
  final bool canLoadMore;

  /// The current offset for the loaded list.
  final int offset;

  /// Creates a new [CustomerListData] with the default values.
  const BankingProductTransactionsListData({
    this.canLoadMore = false,
    this.offset = 0,
  });

  @override
  List<Object?> get props => [
        canLoadMore,
        offset,
      ];

  /// Creates a new object based on this one.
  BankingProductTransactionsListData copyWith({
    bool? canLoadMore,
    int? offset,
  }) =>
      BankingProductTransactionsListData(
        canLoadMore: canLoadMore ?? this.canLoadMore,
        offset: offset ?? this.offset,
      );

  @override
  bool get stringify => true;
}
