import '../../dtos/financial/income_expense_dto.dart';
import '../../network.dart';

/// Provides data related to account incomes and expenses
class IncomeExpenseProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [IncomeExpenseProvider] instance
  IncomeExpenseProvider(
    this.netClient,
  );

  /// Returns all  incomes and expenses of the supplied customer account
  Future<List<IncomeExpenseDTO>> getIncomeExpense({
    required String accountId,
    required int? fromDate,
    required int? toDate,
    required String? interval,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.incomeExpense,
      method: NetRequestMethods.get,
      queryParameters: {
        'interval': interval,
        'from_date': fromDate,
        'to_date': toDate,
        'account_id': accountId,
      },
    );

    return IncomeExpenseDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data));
  }
}
