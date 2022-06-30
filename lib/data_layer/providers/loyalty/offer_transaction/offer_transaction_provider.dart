import '../../../dtos.dart';
import '../../../network.dart';

/// A provider that handles API requests related to the offer transactions.
class OfferTransactionProvider {
  /// The NetClient to use for the network requests.
  final NetClient netClient;

  /// Creates [OfferTransactionProvider].
  OfferTransactionProvider({
    required this.netClient,
  });

  /// Returns the offer transactions for the provided parameters.
  Future<OfferTransactionResponseDTO> getOfferTransactions({
    RewardTypeDTO? rewardType,
    DateTime? from,
    DateTime? to,
    int? offset,
    int? limit,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.offerTransactions,
      queryParameters: {
        if (rewardType != null) 'type': rewardType.value,
        if (from != null) 'ts_created_after': from,
        if (to != null) 'ts_created_before': to,
        if (offset != null) 'offset': offset,
        if (limit != null) 'limit': limit,
        'status': OfferTransactionStatusDTO.complete.value,
      },
      forceRefresh: forceRefresh,
    );

    return OfferTransactionResponseDTO.fromJson(response.data);
  }
}
