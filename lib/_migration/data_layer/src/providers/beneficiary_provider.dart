import '../../../../data_layer/network.dart';
import '../dtos.dart';

/// Provides data about the Beneficiaries
class BeneficiaryProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [BeneficiaryProvider] with the supplied netClient.
  BeneficiaryProvider(
    this.netClient,
  );

  /// Returns a list of beneficiaries.
  ///
  /// If the search text is supplied, will filter the results.
  Future<List<BeneficiaryDTO>> list({
    required String customerID,
    String? searchText,
    bool ascendingOrder = true,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.beneficiary,
      method: NetRequestMethods.get,
      queryParameters: {
        'beneficiary.customer_id': customerID,
        'asc': ascendingOrder,
        'limit': limit,
        'offset': offset,
        if (searchText?.isNotEmpty ?? false) 'q': searchText,
      },
      forceRefresh: forceRefresh,
    );

    return BeneficiaryDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
