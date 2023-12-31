import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import 'base_cubit/base_state.dart';

/// Represents the state of [BankingProductTransactionsCubit]
class BankingProductTransactionsState
    extends BaseState<BankingProductTransactionsAction, void, void> {
  /// List of [BankingProductTransactions] of the customer [BankingProduct]
  final List<BankingProductTransaction>? transactions;

  /// [BankingProduct] id which will be used by this cubit
  final String? accountId;

  /// [BankingProduct] id which will be used by this cubit
  final String? cardId;

  /// Has all the data needed to handle the list of [BankingCard].
  final BankingProductTransactionsListData listData;

  /// Start date filter
  final DateTime? startDate;

  /// End date filter
  final DateTime? endDate;

  /// Amount from filter
  final double? amountFrom;

  /// Amount to filter
  final double? amountTo;

  /// Credit and debit filter
  final bool? credit;

  /// Receipt of the transaction
  final List<int>? receipt;

  /// For the receipt loading
  final BankingProductTransaction? currentTransaction;

  /// To check if credit is selected or not
  final bool? isTypeSelected;

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
    this.isTypeSelected,
    this.currentTransaction,
    this.listData = const BankingProductTransactionsListData(),
  });

  @override
  List<Object?> get props => [
        actions,
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
        currentTransaction,
        isTypeSelected,
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
    bool? isTypeSelected,
    List<int>? receipt,
    BankingProductTransaction? currentTransaction,
    bool resetFilter = false,
  }) =>
      BankingProductTransactionsState(
        transactions: transactions ?? this.transactions,
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        accountId: accountId ?? this.accountId,
        cardId: cardId ?? this.cardId,
        listData: listData ?? this.listData,
        startDate: resetFilter ? null : startDate ?? this.startDate,
        endDate: resetFilter ? null : endDate ?? this.endDate,
        amountFrom: resetFilter ? null : amountFrom ?? this.amountFrom,
        amountTo: resetFilter ? null : amountTo ?? this.amountTo,
        credit: resetFilter
            ? null
            : (isTypeSelected ?? false)
                ? (credit ?? this.credit)
                : null,
        receipt: receipt ?? this.receipt,
        isTypeSelected:
            resetFilter ? null : isTypeSelected ?? this.isTypeSelected,
        currentTransaction: currentTransaction ?? this.currentTransaction,
      );

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
