import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the payments data
class PaymentRepository {
  final PaymentProvider _provider;

  /// Creates a new repository with the supplied [PaymentProvider]
  PaymentRepository(
    PaymentProvider provider,
  ) : _provider = provider;

  /// Lists all the payments of a customer in this
  /// limit/offset
  Future<List<Payment>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool recurring = false,
  }) async {
    final paymentDTOs = await _provider.list(
      customerId: customerId,
      offset: offset,
      limit: limit,
      forceRefresh: forceRefresh,
      recurring: recurring,
    );

    return paymentDTOs.map((e) => e.toPayment()).toList(growable: false);
  }
}
