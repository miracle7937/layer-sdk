import '../../domain_layer/models/min_max_transaction_amount.dart';
import 'base_cubit/base_state.dart';

/// Represents the state of [MinMaxTransactionAmountCubit]
class MinMaxTransactionAmountState
    extends BaseState<MinMaxTransactionAmountAction, void, void> {
  /// [MinMaxTransactionAmount] id which will be used by this cubit
  final String? accountId;

  /// [MinMaxTransactionAmount] id which will be used by this cubit
  final String? cardId;

  ///
  final MinMaxTransactionAmount? filters;

  /// Creates a new instance of [MinMaxTransactionAmountState]
  MinMaxTransactionAmountState({
    this.accountId,
    this.cardId,
    this.filters,
    super.actions = const <MinMaxTransactionAmountAction>{},
    super.errors = const <CubitError>{},
  });

  @override
  List<Object?> get props => [
        accountId,
        cardId,
        filters,
      ];

  /// Creates a new instance of [MinMaxTransactionAmountState]
  /// based on the current instance
  MinMaxTransactionAmountState copyWith({
    Set<MinMaxTransactionAmountAction>? actions,
    Set<CubitError>? errors,
    String? accountId,
    String? cardId,
    MinMaxTransactionAmount? filters,
  }) {
    return MinMaxTransactionAmountState(
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
enum MinMaxTransactionAmountAction {
  /// Loading the balances
  loadFilters,
}
