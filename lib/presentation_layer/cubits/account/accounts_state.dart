import 'package:collection/collection.dart';

import '../../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum AccountsAction {
  /// Loading the financial data.
  financialData,

  /// Loading the accounts.
  accounts,
}

/// The state for the [AccountsCubit].
class AccountsState extends BaseState<AccountsAction, void, void> {
  /// Financial Data received
  final FinancialData? financialData;

  /// List of source [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// Creates a new [AccountsState].
  AccountsState({
    super.actions = const <AccountsAction>{},
    super.errors = const <CubitError>{},
    Iterable<Account> accounts = const <Account>[],
    this.financialData,
  }) : accounts = UnmodifiableListView(accounts);

  @override
  AccountsState copyWith({
    Set<AccountsAction>? actions,
    Set<CubitError>? errors,
    Iterable<Account>? accounts,
    FinancialData? financialData,
  }) =>
      AccountsState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
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

  /// Getting account by id.
  Account getAccountById(String id) =>
      accounts.firstWhereOrNull((account) => account.id == id) ?? Account();
}
