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
  ///
  /// Use the [limit] and [offset] parameters for pagination purposes.
  /// The [query] parameter can bu used for filtering the results.
  Future<List<BankDTO>> listByCountryCode({
    required String countryCode,
    int? limit,
    int? offset,
    String? query,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.bank,
      method: NetRequestMethods.get,
      queryParameters: {
        'country_code': countryCode,
        'status': 'A',
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (query?.isNotEmpty ?? false) 'q': query,
      },
      forceRefresh: forceRefresh,
    );

    return BankDTO.fromJsonList(
      List<Map<String, dynamic>>.from(
        response.data is List ? response.data : response.data['banks'],
      ),
    );
  }
}
