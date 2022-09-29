import '../../../features/financial_data.dart';

/// An abstract repository for the financial data
abstract class FinancialDataRepositoryInterface {
  /// Retrieves the financial data of the supplied `customerId`
  Future<FinancialData> loadFinancialData({
    String? customerId,
    bool forceRefresh = false,
  });
}
