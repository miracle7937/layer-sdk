import '../../network.dart';
import '../dtos.dart';

///Provides data about the currencies
class CurrencyProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [CurrencyProvider] with the supplied netClient.
  CurrencyProvider({
    required this.netClient,
  });

  /// Returns a list of currencies.
  Future<List<CurrencyDTO>> list({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.currency,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );
    return CurrencyDTO.fromJsonList(response.data);
  }

  /// Gets a currency by a code
  Future<List<CurrencyDTO>> getCurrencyByCode({
    required String code,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.currency,
      method: NetRequestMethods.get,
      queryParameters: {
        'currency': code,
      },
      forceRefresh: forceRefresh,
    );
    return CurrencyDTO.fromJsonList(response.data);
  }
}
