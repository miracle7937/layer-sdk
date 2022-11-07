import '../../domain_layer/models/transactions_filters.dart';
import 'base_cubit/base_state.dart';

/// Represents the state of [TransactionFiltersCubit]
class TransactionFiltersState
    extends BaseState<TransactionFiltersAction, void, void> {
  /// [TransactionFilters] id which will be used by this cubit
  final String? accountId;

  /// [TransactionFilters] id which will be used by this cubit
  final String? cardId;

  ///
  final TransactionFilters? filters;

  /// Creates a new instance of [TransactionFiltersState]
  TransactionFiltersState({
    this.accountId,
    this.cardId,
    this.filters,
    super.actions = const <TransactionFiltersAction>{},
    super.errors = const <CubitError>{},
  });

  @override
  List<Object?> get props => [
        accountId,
        cardId,
        filters,
      ];

  /// Creates a new instance of [TransactionFiltersState]
  /// based on the current instance
  TransactionFiltersState copyWith({
    Set<TransactionFiltersAction>? actions,
    Set<CubitError>? errors,
    String? accountId,
    String? cardId,
    TransactionFilters? filters,
  }) {
    return TransactionFiltersState(
      actions: actions ?? super.actions,
      errors: errors ?? super.errors,
      accountId: accountId ?? this.accountId,
      cardId: cardId ?? this.cardId,
      filters: filters ?? this.filters,
    );
  }

  @override
  bool get stringify => true;
}

/// Enum for possible actions
enum TransactionFiltersAction {
  /// Loading the balances
  loadFilters,
}
