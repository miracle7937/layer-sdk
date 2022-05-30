import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles the financial data
class FinancialDataRepository {
  final FinancialDataProvider _provider;

  /// Creates a new [FinancialDataRepository] instance
  FinancialDataRepository(this._provider);

  /// Retrieves the financial data of the supplied customer
  Future<FinancialData> loadFinancialData({
    required String customerId,
    bool forceRefresh = false,
  }) async {
    final financialDataDTO = await _provider.financialData(
      customerId: customerId,
      forceRefresh: forceRefresh,
    );

    return financialDataDTO.toFinancialData();
  }
}
