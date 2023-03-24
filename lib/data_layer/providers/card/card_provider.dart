import 'dart:async';

import '../../../../data_layer/network.dart';
import '../../dtos.dart';
import '../../helpers.dart';

/// Provides data related to Cards
class CardProvider {
  /// NetClient used for network requests
  final NetClient netClient;

  /// Creates a new [CardProvider] instance
  CardProvider(this.netClient);

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
        if (isNotEmpty(customerId)) 'customer_id': customerId,
        'include_details': includeDetails,
      },
      forceRefresh: forceRefresh,
    );

    return CardDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
