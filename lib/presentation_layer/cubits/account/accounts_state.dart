import 'dart:collection';

import '../../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum AccountsAction {
  /// Loading the financial data.
  financialData,

  /// Loading the accounts.
  accounts,
}

/// The available events that the cubit can emit.
enum AccountsEvent {
  /// Event for showing the financial data view.
  showFinancialData,

  /// Event for showing the accounts view.
  showAccounts,
}

/// The available validation error codes.
enum AccountsValidationErrorCode {
  /// Source account validation error.
  sourceAccountValidationError,
}

/// The state for the [AccountsCubit].
class AccountsState extends BaseState<AccountsAction, AccountsEvent,
    AccountsValidationErrorCode> {
  /// Financial Data received
  final FinancialData? financialData;

  /// List of source [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// Creates a new [AccountsState].
  AccountsState({
    super.actions = const <AccountsAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AccountsEvent>{},
    Iterable<Account> accounts = const <Account>[],
    this.financialData,
  }) : accounts = UnmodifiableListView(accounts);

  @override
  AccountsState copyWith({
    Set<AccountsAction>? actions,
    Set<AccountsEvent>? events,
    Set<CubitError>? errors,
    Iterable<Account>? accounts,
    FinancialData? financialData,
  }) =>
      AccountsState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        accounts: accounts ?? this.accounts,
        financialData: financialData ?? this.financialData,
      );

  @override
  List<Object?> get props => [
        errors,
        actions,
        events,
        accounts,
        financialData,
      ];
}
