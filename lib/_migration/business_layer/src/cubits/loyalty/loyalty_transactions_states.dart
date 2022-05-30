import 'dart:collection';

import 'package:equatable/equatable.dart';
import '../../../../data_layer/data_layer.dart';

import '../../utils/pagination.dart';

/// Handles LoyaltyTransaction error status
enum LoyaltyTransactionErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

///State container for [LoyaltyTransactionCubit]
class LoyaltyTransactionState extends Equatable {
  /// True if the cubit is processing something.
  final bool busy;

  /// The list of transactions
  final UnmodifiableListView<LoyaltyTransaction> transactions;

  /// Current error status
  final LoyaltyTransactionErrorStatus errorStatus;

  /// Handles transaction pagination
  final Pagination pagination;

  /// True id the cubit is loading more transactions
  final bool loadingMore;

  /// Creates a new [LoyaltyTransactionsState].
  LoyaltyTransactionState({
    Iterable<LoyaltyTransaction> transactions = const <LoyaltyTransaction>[],
    this.busy = false,
    this.errorStatus = LoyaltyTransactionErrorStatus.none,
    this.pagination = const Pagination(limit: 20),
    this.loadingMore = false,
  }) : transactions = UnmodifiableListView(transactions);

  @override
  List<Object?> get props =>
      [transactions, busy, errorStatus, pagination, loadingMore];

  /// Clones [LoyaltyTransactionsState] object
  LoyaltyTransactionState copyWith({
    bool? busy,
    Iterable<LoyaltyTransaction>? transactions,
    LoyaltyTransactionErrorStatus? errorStatus,
    Pagination? pagination,
    bool? loadingMore,
  }) {
    return LoyaltyTransactionState(
      busy: busy ?? this.busy,
      transactions: transactions ?? this.transactions,
      errorStatus: errorStatus ?? this.errorStatus,
      pagination: pagination ?? this.pagination,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}
