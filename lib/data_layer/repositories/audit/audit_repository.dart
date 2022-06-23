import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles audits data
class AuditRepository implements AuditRepositoryInterface {
  final AuditProvider _provider;

  /// Creates a new [AuditRepository] with the supplied [AuditProvider]
  AuditRepository({
    required AuditProvider provider,
  }) : _provider = provider;

  /// Retrieves audits of the given customer
  @override
  Future<List<Audit>> listCustomerAudits({
    required String customerId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
    AuditSort sortBy = AuditSort.date,
    bool descendingOrder = true,
    String? searchText,
  }) async {
    final dtos = await _provider.listCustomerAudits(
      customerID: customerId,
      limit: limit,
      offset: offset,
      sortBy: sortBy.toFieldName(),
      descendingOrder: descendingOrder,
      searchText: searchText,
    );

    return dtos.map((e) => e.toAudit()).toList(growable: false);
  }
}
