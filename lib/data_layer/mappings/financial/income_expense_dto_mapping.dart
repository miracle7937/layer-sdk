import '../../../domain_layer/models/financial/income_expense.dart';
import '../../dtos/financial/income_expense_dto.dart';

/// Extension that provides mapping for [IncomeExpenseDTO]
extension IncomeExpenseDTOMapping on IncomeExpenseDTO {
  /// Maps a [IncomeExpenseDTO] instance to a [IncomeExpense] model
  IncomeExpense toIncomeExpense() => IncomeExpense(
        income: income,
        expense: expense,
        periodEndDate: periodEndDate,
        periodStartDate: periodStartDate,
        prefCurrency: prefCurrency,
      );
}
