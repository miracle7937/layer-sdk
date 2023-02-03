import '../../dtos.dart';
import '../../network.dart';

/// Provides data about customer's upcoming payments
class UpcomingPaymentProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [UpcomingPaymentDTO] with the supplied [NetClient].
  UpcomingPaymentProvider({
    required this.netClient,
  });

  /// Returns the upcoming payments
  ///
  /// When indicating the [cardId] or [type], it will only get the upcoming
  /// payments for that card and of that type.
  Future<List<UpcomingPaymentDTO>> list({
    String? cardId,
    UpcomingPaymentTypeDTO? type,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.upcomingPayment,
      method: NetRequestMethods.get,
      queryParameters: {
        if (cardId != null) 'account_loan_payment_card_id': cardId,
        if (type != null) 'type': type.value,
      },
      forceRefresh: forceRefresh,
    );

    return UpcomingPaymentDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data['upcoming_payments']),
    );
  }
}
