import '../../../../data_layer/network.dart';
import '../../dtos.dart';

/// Provides data related to Cards
class CardProvider {
  /// NetClient used for network requests
  final NetClient netClient;

  /// Creates a new [CardProvider] instance
  CardProvider(
    this.netClient,
  );

  /// Returns all cards of the supplied customer
  Future<List<CardDTO>> listCustomerCards({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.card,
      method: NetRequestMethods.get,
      queryParameters: {
        'customer_id': customerId,
        'include_details': includeDetails,
      },
      forceRefresh: forceRefresh,
    );

    return CardDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Returns all completed transactions of the supplied customer card
  Future<List<CardTransactionDTO>> listCustomerCardTransactions({
    required String cardId,
    String? customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.transaction,
      method: NetRequestMethods.get,
      queryParameters: {
        'customer_id': customerId,
        'card_id': cardId,
        'status': 'C',
        'limit': limit,
        'offset': offset,
      },
      forceRefresh: forceRefresh,
    );

    return CardTransactionDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
