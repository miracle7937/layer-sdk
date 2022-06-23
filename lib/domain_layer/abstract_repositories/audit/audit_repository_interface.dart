import '../../../features/audit.dart';

/// The abstract repository for the audits.
abstract class AuditRepositoryInterface {
  /// Retrieves audits of the given customer.
  Future<List<Audit>> listCustomerAudits({
    required String customerId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
    AuditSort sortBy = AuditSort.date,
    bool descendingOrder = true,
    String? searchText,
  });
}
