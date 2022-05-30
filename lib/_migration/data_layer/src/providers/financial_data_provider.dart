import '../../../../data_layer/network.dart';
import '../dtos.dart';

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
    required String customerId,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.financialData}/$customerId',
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return FinancialDataDTO.fromJson(response.data);
  }
}
