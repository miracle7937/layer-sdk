import '../../dtos.dart';
import '../../network.dart';

/// Provides data related to financial data for accounts and card
class FinancialDataProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [FinancialDataProvider] instance
  FinancialDataProvider(
    this.netClient,
  );

  /// Returns financial data of a customer
  Future<FinancialDataDTO> financialData({
    String? customerId,
    bool forceRefresh = false,
  }) async {
    final requestPath = customerId != null
        ? '${netClient.netEndpoints.financialData}/$customerId'
        : '${netClient.netEndpoints.financialData}';

    final response = await netClient.request(
      requestPath,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return FinancialDataDTO.fromJson(response.data);
  }
}
