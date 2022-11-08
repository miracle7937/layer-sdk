import '../../../data_layer/dtos/financial/income_expense_dto.dart';
import '../../models/financial/income_expense.dart';

/// The abstract repository for the account incomes and expenses.
abstract class IncomeExpenseRepositoryInterface {
  /// Returns all incomes expenses of the supplied customer account
  Future<List<IncomeExpense>> getIncomeExpense(
      {required String accountId,
      DateTime? fromDate,
      DateTime? toDate,
      IncomeExpenseInterval interval = IncomeExpenseInterval.month});
}
