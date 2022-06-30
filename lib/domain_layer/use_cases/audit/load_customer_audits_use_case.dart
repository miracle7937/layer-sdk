import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading the audits related to a customer.
class LoadCustomerAuditsUseCase {
  final AuditRepositoryInterface _repository;

  /// Creates a new [LoadCustomerAuditsUseCase].
  const LoadCustomerAuditsUseCase({
    required AuditRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns the list of audits related to the passed customer id.
  ///
  /// Use the [limit] and [offset] values for pagination purposes.
  /// The [searchText] is used for filtering the audits.
  /// Use the [sortBy] to indicate what fields should the list be sorted by.
  /// If [descendingOrder] is true, the results will be sorted descending.
  Future<List<Audit>> call({
    required String customerId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
    String? searchText,
    AuditSort sortBy = AuditSort.date,
    bool descendingOrder = true,
  }) =>
      _repository.listCustomerAudits(
        customerId: customerId,
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
        searchText: searchText,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
      );
}
