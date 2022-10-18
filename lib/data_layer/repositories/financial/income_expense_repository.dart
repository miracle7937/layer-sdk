import '../../../domain_layer/abstract_repositories/financial/income_expense_repository_interface.dart';
import '../../../domain_layer/models/financial/income_expense.dart';
import '../../mappings/financial/income_expense_dto_mapping.dart';
import '../../providers/financial/income_expense_provider.dart';

/// Handles all the account balance data
class IncomeExpenseRepository implements IncomeExpenseRepositoryInterface {
  final IncomeExpenseProvider _provider;

  /// Creates a new [IncomeExpenseRepository] instance
  IncomeExpenseRepository(this._provider);

  // Returns all completed balance of the supplied customer account
  @override
  Future<List<IncomeExpense>> getIncomeExpense({
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  }) async {
    final incomeExpensesDTOs = await _provider.getIncomeExpense(
      accountId: accountId,
      fromDate: fromDate,
      toDate: toDate,
      interval: interval,
    );
    return incomeExpensesDTOs
        .map((x) => x.toIncomeExpense())
        .toList(growable: false);
  }
}
