import '../../models/financial/income_expense.dart';

/// The abstract repository for the account incomes and expenses.
abstract class IncomeExpenseRepositoryInterface {
  /// Returns all incomes expenses of the supplied customer account
  Future<List<IncomeExpense>> getIncomeExpense({
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  });
}

