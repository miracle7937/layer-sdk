import '../../../_migration/data_layer/providers.dart';
import '../../../_migration/data_layer/src/mappings.dart';
import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';

/// Handles all the standing orders data
class StandingOrderRepository implements StandingOrdersRepositoryInterface {
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
  @override
  Future<List<StandingOrder>> list({
    required String customerId,
    int? limit,
    int? offset,
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
