import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the frequent payments data
class FrequentPaymentRepository implements FrequentPaymentsRepositoryInterface {
  final PaymentProvider _provider;

  /// Creates a new repository with the supplied [PaymentProvider]
  FrequentPaymentRepository(
    PaymentProvider provider,
  ) : _provider = provider;

  /// Lists the frequent payments of a customer
  /// Use the `limit` and `offset` params to paginate.
  Future<List<Payment>> getFrequentPayments({
    int limit = 50,
    int offset = 0,
  }) async {
    final paymentDTOs = await _provider.getFrequentPayments(
      offset: offset,
      limit: limit,
    );

    return paymentDTOs.map((e) => e.toPayment()).toList(growable: false);
  }
}
