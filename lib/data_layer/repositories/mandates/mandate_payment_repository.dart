import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models/mandates/payment/mandate_payment.dart';
import '../../mappings.dart';
import '../../providers/mandates/mandates_payment_provider.dart';

/// Handles Mandate Payments
class MandatePaymentRepository implements MandatePaymentRepositoryInterface {
  final MandatePaymentsProvider _provider;

  /// Creates a new [MandatePaymentRepository]
  const MandatePaymentRepository({
    required MandatePaymentsProvider provider,
  }) : _provider = provider;

  @override
  Future<List<MandatePayment>> fetchMandatePayments({
    int? limit,
    int? offset,
    String? sortBy,

    /// If the sort is descending or not
    bool desc = false,
  }) async {
    final mandatePaymentsDTO = await _provider.fetchMandatePayments(
      limit: limit,
      offset: offset,
      sortBy: sortBy,
      desc: desc,
    );

    return mandatePaymentsDTO
        .map((it) => it.toMandatePaymentDTO())
        .toList(growable: false);
  }
}
