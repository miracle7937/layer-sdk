import '../../models.dart';

/// An abstract repository for the financial data
abstract class FinancialDataRepositoryInterface {
  /// Retrieves the financial data of the supplied `customerId`
  Future<FinancialData> loadFinancialData({
    required String customerId,
    bool forceRefresh = false,
  });
}
