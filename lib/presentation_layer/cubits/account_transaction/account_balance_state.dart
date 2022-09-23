import 'dart:collection';
import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// Represents the state of [AccountBalanceCubit]
class AccountBalanceState extends BaseState<AccountBalanceAction, void,
    AccountBalanceValidationErrorCode> {
  /// List of [AccountBalance] of the customer [Account]
  final UnmodifiableListView<AccountBalance> balances;

  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// [Account] id which will be used by this cubit
  final String accountId;

  ///
  final DateTime startDate;

  ///
  final DateTime endDate;

  /// Creates a new instance of [AccountBalanceState]
  AccountBalanceState({
    required this.customerId,
    required this.accountId,
    required this.startDate,
    required this.endDate,
    Iterable<AccountBalance> balances = const [],
  }) : balances = UnmodifiableListView(balances);

  @override
  List<Object?> get props => [
        balances,
        customerId,
        accountId,
        endDate,
        startDate,
      ];

  /// Creates a new instance of [AccountBalanceState]
  /// based on the current instance
  AccountBalanceState copyWith({
    Iterable<AccountBalance>? balances,
    String? accountId,
    String? customerId,
    Set<AccountBalanceAction>? actions,
    Set<CubitError>? errors,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AccountBalanceState(
      balances: balances ?? this.balances,
      customerId: customerId ?? this.customerId,
      accountId: accountId ?? this.accountId,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  bool get stringify => true;
}

/// Enum for all possible errors for [AccountBalanceCubit]
enum AccountBalanceValidationErrorCode {
  /// Generic error
  generic,
}

/// Enum for possible actions
enum AccountBalanceAction {
  /// Loading the balances
  loadInitialBalances,

  /// Loading balances after changing the week
  loadDifferentWeekBalances,
}
