import 'dart:collection';
import '../../../domain_layer/models.dart';
import '../base_cubit/base_state.dart';

/// Represents the state of [AccountBalanceCubit]
class AccountBalanceState extends BaseState<AccountBalanceAction, void,
    AccountBalanceValidationErrorCode> {
  /// List of [AccountBalance] of the customer [Account]
  final UnmodifiableListView<AccountBalance> balances;

  /// [Account] id which will be used by this cubit
  final String accountId;

  /// The week start date for fetching the balances
  final DateTime startDate;

  /// The week end date for fetching the balances
  final DateTime endDate;

  /// Creates a new instance of [AccountBalanceState]
  AccountBalanceState({
    required this.accountId,
    required this.startDate,
    required this.endDate,
    super.actions = const <AccountBalanceAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AccountBalanceEvent>{},
    Iterable<AccountBalance> balances = const [],
  }) : balances = UnmodifiableListView(balances);

  @override
  List<Object?> get props => [
        balances,
        accountId,
        endDate,
        startDate,
      ];

  /// Creates a new instance of [AccountBalanceState]
  /// based on the current instance
  AccountBalanceState copyWith({
    Iterable<AccountBalance>? balances,
    String? accountId,
    Set<AccountBalanceAction>? actions,
    Set<CubitError>? errors,
    Set<AccountBalanceEvent>? events,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return AccountBalanceState(
      actions: actions ?? super.actions,
      errors: errors ?? super.errors,
      events: const <AccountBalanceEvent>{},
      balances: balances ?? this.balances,
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

  /// Changing the date
  changeDate,
}

/// Enum for possible events
enum AccountBalanceEvent {
  /// No events 
  none,
}
