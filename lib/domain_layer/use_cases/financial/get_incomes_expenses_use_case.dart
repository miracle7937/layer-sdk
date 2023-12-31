import '../../../data_layer/dtos/financial/income_expense_dto.dart';
import '../../abstract_repositories/financial/income_expense_repository_interface.dart';
import '../../models/financial/income_expense.dart';

/// Use case for the account incomes and expenses
class IncomeExpenseUseCase {
  final IncomeExpenseRepositoryInterface _repository;

  /// Creates a new [IncomeExpenseUseCase].
  const IncomeExpenseUseCase({
    required IncomeExpenseRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the accounts incomes and expenses
  Future<List<IncomeExpense>> call(
          {required String accountId,
          DateTime? fromDate,
          DateTime? toDate,
          IncomeExpenseInterval interval = IncomeExpenseInterval.month}) =>
      _repository.getIncomeExpense(
        accountId: accountId,
        interval: interval,
        fromDate: fromDate,
        toDate: toDate,
      );
}
