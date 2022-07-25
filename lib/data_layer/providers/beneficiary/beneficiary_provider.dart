import '../../../../data_layer/network.dart';
import '../../dtos.dart';

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
    String? customerID,
    String? searchText,
    bool ascendingOrder = true,
    int? limit,
    int? offset,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.beneficiary,
      method: NetRequestMethods.get,
      queryParameters: {
        if (customerID != null) 'beneficiary.customer_id': customerID,
        'asc': ascendingOrder,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (searchText?.isNotEmpty ?? false) 'q': searchText,
      },
      forceRefresh: forceRefresh,
    );

    return BeneficiaryDTO.fromJsonList(response.data);
  }
}
