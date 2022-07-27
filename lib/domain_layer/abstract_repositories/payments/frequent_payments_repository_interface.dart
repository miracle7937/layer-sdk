import '../../models.dart';

/// Abstract definition of the repository that handles
/// all the frequent payments data.
abstract class FrequentPaymentsRepositoryInterface {
  /// Lists the frequent payments of a customer
  ///
  /// Use the `limit` and `offset` params to paginate.
  Future<List<Payment>> getFrequentPayments({
    int limit = 50,
    int offset = 0,
  });
}
