import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the transfers data
class TransferRepository {
  final TransferProvider _provider;

  /// Creates a new repository with the supplied [TransferProvider]
  TransferRepository(TransferProvider provider) : _provider = provider;

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
  }) async {
    final transferDTOs = await _provider.list(
      customerId: customerId,
      limit: limit,
      offset: offset,
      includeDetails: includeDetails,
      recurring: recurring,
      forceRefresh: forceRefresh,
    );

    return transferDTOs.map((e) => e.toTransfer()).toList(growable: false);
  }
}
