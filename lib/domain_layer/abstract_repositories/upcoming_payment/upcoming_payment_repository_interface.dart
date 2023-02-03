import '../../../features/upcoming_payment.dart';

/// Abstract repository for the upcoming payments.
abstract class UpcomingPaymentRepositoryInterface {
  /// Lists all the upcoming payments
  ///
  /// When indicating the cardId, it will only get the upcoming payments
  /// for that card
  ///
  /// Use the [type] parameter for filtering the results.
  Future<List<UpcomingPayment>> list({
    String? cardId,
    UpcomingPaymentType? type,
    bool forceRefresh = false,
  });
}
