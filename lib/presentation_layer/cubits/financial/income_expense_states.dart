import 'dart:collection';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/models/financial/income_expense.dart';
import '../base_cubit/base_state.dart';

/// Represents the state of [IncomeExpenseCubit]
class IncomeExpenseState extends BaseState<IncomeExpenseAction, void, void> {
  /// List of [IncomeExpense] of the customer [Account]
  final UnmodifiableListView<IncomeExpense> incomeExpense;

  /// [Account] id which will be used by this cubit
  final String accountId;

  /// The week start date for fetching the incomeExpense
  final DateTime startDate;

  /// The week end date for fetching the incomeExpense
  final DateTime endDate;

  /// Creates a new instance of [IncomeExpenseState]
  IncomeExpenseState({
    required this.accountId,
    required this.startDate,
    required this.endDate,
    super.actions = const <IncomeExpenseAction>{},
    super.errors = const <CubitError>{},
    Iterable<IncomeExpense> incomeExpense = const [],
  }) : incomeExpense = UnmodifiableListView(incomeExpense);

  @override
  List<Object?> get props => [
        actions,
        errors,
        incomeExpense,
        accountId,
        endDate,
        startDate,
      ];

  /// Creates a new instance of [IncomeExpenseState]
  /// based on the current instance
  IncomeExpenseState copyWith({
    Iterable<IncomeExpense>? incomeExpense,
    String? accountId,
    Set<IncomeExpenseAction>? actions,
    Set<CubitError>? errors,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return IncomeExpenseState(
      actions: actions ?? super.actions,
      errors: errors ?? super.errors,
      incomeExpense: incomeExpense ?? this.incomeExpense,
      accountId: accountId ?? this.accountId,
      endDate: endDate ?? this.endDate,
      startDate: startDate ?? this.startDate,
    );
  }

  @override
  bool get stringify => true;
}

/// Enum for possible actions
enum IncomeExpenseAction {
  /// Loading
  load,
}
