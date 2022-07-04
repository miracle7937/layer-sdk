import '../../models.dart';

/// An abstract repository for the [Transfer]
abstract class TransferRepositoryInterface {
  /// Lists the transfers from a customer.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Transfer>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool includeDetails = true,
    bool recurring = false,
    bool forceRefresh = false,
  });
}
