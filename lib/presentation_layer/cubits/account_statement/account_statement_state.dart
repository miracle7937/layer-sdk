import 'package:collection/collection.dart';

import '../../cubits.dart';

/// The available busy actions that the cubit can perform.
enum AccountStatementAction {
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
  /// Start date.
  final DateTime? startDate;

  /// End date.
  final DateTime? endDate;

  /// The statement file list of bytes
  final UnmodifiableListView<int> statementBytes;

  /// If user can proceed in getting statement.
  bool get canContinue => startDate != null && endDate != null;

  /// Creates a new [AccountStatementState].
  AccountStatementState({
    super.actions = const <AccountStatementAction>{},
    super.errors = const <CubitError>{},
    super.events = const <AccountStatementEvent>{},
    Iterable<int> statementBytes = const <int>[],
    this.startDate,
    this.endDate,
  }) : statementBytes = UnmodifiableListView(statementBytes);

  @override
  AccountStatementState copyWith({
    Set<AccountStatementAction>? actions,
    Set<CubitError>? errors,
    Set<AccountStatementEvent>? events,
    DateTime? startDate,
    DateTime? endDate,
    Iterable<int>? statementBytes,
  }) =>
      AccountStatementState(
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        statementBytes: statementBytes ?? this.statementBytes,
      );

  @override
  List<Object?> get props => [
        errors,
        actions,
        events,
        startDate,
        endDate,
        statementBytes,
      ];
}
