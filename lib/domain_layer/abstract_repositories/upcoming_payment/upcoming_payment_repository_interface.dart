import '../../models.dart';

/// Abstract repository for the upcoming payments.
abstract class UpcomingPaymentRepositoryInterface {
  /// Lists all the upcoming payments
  ///
  /// When indicating the cardId, it will only get the upcoming payments
  /// for that card
  Future<List<UpcomingPayment>> list({
    String? cardId,
    UpcomingPaymentType? type,
    bool forceRefresh = false,
  });

  /// Lists all the upcoming payments for this customer
  Future<UpcomingPaymentGroup> listAllUpcomingPayments({
    required String customerID,
    int? limit,
    int? offset,
    bool forceRefresh = false,
  });
}
