import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the standing orders data
class StandingOrderRepository {
  final TransferProvider _provider;

  /// Creates a new repository with the supplied [TransferProvider]
  ///
  /// Uses the [TransferProvider], but takes the data using the recurring
  /// property set to true.
  StandingOrderRepository(
    TransferProvider provider,
  ) : _provider = provider;

  /// Lists the standing orders from a customer.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<StandingOrder>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    final transferDTOs = await _provider.list(
      customerId: customerId,
      limit: limit,
      offset: offset,
      includeDetails: includeDetails,
      recurring: true,
      forceRefresh: forceRefresh,
    );

    return transferDTOs
        .map(
          (e) => e.toStandingOrder(),
        )
        .toList(growable: false);
  }
}
