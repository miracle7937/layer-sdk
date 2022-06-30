import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles checkbook data
class CheckbookRepository implements CheckbookRepositoryInterface {
  final CheckbookProvider _provider;

  /// Creates a new [CheckbookRepository] with the supplied [CheckbookProvider]
  CheckbookRepository({
    required CheckbookProvider provider,
  }) : _provider = provider;

  /// List checkbooks of the provided customer ID
  ///
  /// The [limit] and [offset] parameters can be used for pagination purposes.
  /// Use the [sort] field for filtering.
  @override
  Future<List<Checkbook>> list({
    required String customerId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
    CheckbookSort? sort,
    bool descendingOrder = true,
  }) async {
    final dtos = await _provider.listCustomerCheckbooks(
      customerId: customerId,
      forceRefresh: forceRefresh,
      limit: limit,
      offset: offset,
      sortBy: sort?.toFieldName(),
      descendingOrder: descendingOrder,
    );

    return dtos.map((e) => e.toCheckbook()).toList(growable: false);
  }
}
