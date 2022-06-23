import '../../models.dart';

/// An abstract repository for the standing orders
abstract class StandingOrdersRepositoryInterface {
  /// Lists the standing orders from a `customerId`.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<StandingOrder>> list({
    required String customerId,
    int? limit,
    int? offset,
    bool includeDetails = true,
    bool forceRefresh = false,
  });
}
