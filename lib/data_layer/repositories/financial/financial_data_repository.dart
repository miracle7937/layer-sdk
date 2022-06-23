import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles the financial data
class FinancialDataRepository implements FinancialDataRepositoryInterface {
  final FinancialDataProvider _provider;

  /// Creates a new [FinancialDataRepository] instance
  FinancialDataRepository(this._provider);

  /// Retrieves the financial data of the supplied `customerId`
  @override
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
