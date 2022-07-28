import '../../models.dart';

/// The abstract repository for [MandatePayments]
abstract class MandatePaymentRepositoryInterface {
  /// Fetch a list of [MandatePayments]
  Future<List<MandatePayment>> fetchMandatePayments({
    int? limit,
    int? offset,
    String? sortBy,

    /// If the sort is descending or not
    bool desc = false,
  });
}
