import '../../dtos.dart';
import '../../network.dart';

/// Provides the banks data from the API.
class BankProvider {
  /// The NetClient to use for the network requests.
  final NetClient netClient;

  /// Creates a new [BankProvider].
  BankProvider({
    required this.netClient,
  });

  /// Returns a list of banks for the provided country code.
  Future<List<BankDTO>> listByCountryCode({
    required String countryCode,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.bank,
      method: NetRequestMethods.get,
      queryParameters: {
        'country_code': countryCode,
        'status': 'A',
      },
      forceRefresh: forceRefresh,
    );

    return BankDTO.fromJsonList(response.data);
  }
}
