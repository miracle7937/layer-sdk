import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// Represents the state of [AccountTransactionsCubit]
class AccountTransactionsState extends BaseState<AccountTransactionsAction,
    void, AccountTransactionsValidationErrorCode> {
  /// List of [AccountTransactions] of the customer [Account]
  final UnmodifiableListView<AccountTransaction> transactions;

  /// [Account] id which will be used by this cubit
  final String accountId;

  /// Has all the data needed to handle the list of [BankingCard].
  final AccountTransactionsListData listData;

  ///
  final DateTime? startDate;

  ///
  final DateTime? endDate;

  /// Creates a new instance of [AccountTransactionsState]
  AccountTransactionsState({
    required this.accountId,
    Iterable<AccountTransaction> transactions = const [],
    this.startDate,
    super.actions = const <AccountTransactionsAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AccountTransactionsEvent>{},
    this.endDate,
    this.listData = const AccountTransactionsListData(),
  }) : transactions = UnmodifiableListView(transactions);

  @override
  List<Object?> get props => [
        transactions,
        accountId,
        listData,
        startDate,
        endDate,
      ];

  /// Creates a new instance of [AccountTransactionsState]
  /// based on the current instance
  AccountTransactionsState copyWith({
    Iterable<AccountTransaction>? transactions,
    Set<AccountTransactionsAction>? actions,
    Set<CubitError>? errors,
    Set<AccountTransactionsEvent>? events,
    String? accountId,
    AccountTransactionsListData? listData,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AccountTransactionsState(
      transactions: transactions ?? this.transactions,
      actions: actions ?? super.actions,
      errors: errors ?? super.errors,
      events: const <AccountTransactionsEvent>{},
      accountId: accountId ?? this.accountId,
      listData: listData ?? this.listData,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  bool get stringify => true;
}

/// Enum for all possible errors for [AccountTransactionsCubit]
enum AccountTransactionsValidationErrorCode {
  /// Generic error
  generic,
}

/// Enum for possible actions
enum AccountTransactionsAction {
  /// Loading the balances
  loadInitialTransactionss,

  /// Changing the date
  changeDate,
}

/// Enum for possible events
enum AccountTransactionsEvent {
  /// No events
  none,
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
