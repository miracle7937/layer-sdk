import '../../models.dart';

/// The abstract repository for [MandatePayments]
abstract class MandatePaymentRepositoryInterface {
  /// Fetch a list of [MandatePayments]
  Future<List<MandatePayment>> fetchMandatePayments();
}
