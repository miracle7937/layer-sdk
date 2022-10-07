import 'package:collection/collection.dart';

import '../../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum AccountStatementAction {
  /// Loading accounts.
  accounts,

  /// Downloading the account statement.
  statement,
}

/// The available events that the cubit can emit.
enum AccountStatementEvent {
  /// Changing period for statement.
  changingPeriod,

  /// Event for showing the result view.
  showResultView,
}

/// The state for the [AccountStatementCubit].
class AccountStatementState
    extends BaseState<AccountStatementAction, AccountStatementEvent, void> {
  /// List of [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// Exchange result.
  final LoyaltyPointsExchange? exchangeResult;

  /// Start date.
  final DateTime? startDate;

  /// End date.
  final DateTime? endDate;

  /// The statement file list of bytes
  final UnmodifiableListView<int> statementBytes;

  /// Account for downloading statement.
  Account? get account => accounts.firstOrNull;

  /// If user can proceed in getting statement.
  bool get canContinue => startDate != null && endDate != null;

  /// Creates a new [AccountStatementState].
  AccountStatementState({
    super.actions = const <AccountStatementAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AccountStatementEvent>{},
    Iterable<Account> accounts = const <Account>[],
    Iterable<int> certificateBytes = const <int>[],
    this.exchangeResult,
    this.startDate,
    this.endDate,
  })  : accounts = UnmodifiableListView(accounts),
        statementBytes = UnmodifiableListView(certificateBytes);

  @override
  AccountStatementState copyWith({
    Set<AccountStatementAction>? actions,
    Set<CubitError>? errors,
    Set<AccountStatementEvent>? events,
    Iterable<Account>? accounts,
    DateTime? startDate,
    DateTime? endDate,
    Iterable<int>? certificateBytes,
  }) =>
      AccountStatementState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        accounts: accounts ?? this.accounts,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        certificateBytes: certificateBytes ?? this.statementBytes,
      );

  @override
  List<Object?> get props => [
        errors,
        actions,
        events,
        accounts,
        exchangeResult,
        startDate,
        endDate,
        statementBytes,
      ];
}
