import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';
import '../../../utils.dart';

/// Handles Loyalty points transaction error status
enum LoyaltyPointsTransactionErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

///State container for [LoyaltyPointsTransactionCubit]
class LoyaltyPointsTransactionState extends Equatable {
  /// True if the cubit is processing something.
  final bool busy;

  /// The list of transactions
  final UnmodifiableListView<LoyaltyPointsTransaction> transactions;

  /// Current error status
  final LoyaltyPointsTransactionErrorStatus errorStatus;

  /// Handles transaction pagination
  final Pagination pagination;

  /// True id the cubit is loading more transactions
  final bool loadingMore;

  /// Creates a new [LoyaltyPointsTransactionState].
  LoyaltyPointsTransactionState({
    Iterable<LoyaltyPointsTransaction> transactions =
        const <LoyaltyPointsTransaction>[],
    this.busy = false,
    this.errorStatus = LoyaltyPointsTransactionErrorStatus.none,
    this.pagination = const Pagination(limit: 20),
    this.loadingMore = false,
  }) : transactions = UnmodifiableListView(transactions);

  /// Clones [LoyaltyPointsTransactionState] object
  LoyaltyPointsTransactionState copyWith({
    bool? busy,
    Iterable<LoyaltyPointsTransaction>? transactions,
    LoyaltyPointsTransactionErrorStatus? errorStatus,
    Pagination? pagination,
    bool? loadingMore,
  }) =>
      LoyaltyPointsTransactionState(
        busy: busy ?? this.busy,
        transactions: transactions ?? this.transactions,
        errorStatus: errorStatus ?? this.errorStatus,
        pagination: pagination ?? this.pagination,
        loadingMore: loadingMore ?? this.loadingMore,
      );

  @override
  List<Object?> get props => [
        transactions,
        busy,
        errorStatus,
        pagination,
        loadingMore,
      ];
}
