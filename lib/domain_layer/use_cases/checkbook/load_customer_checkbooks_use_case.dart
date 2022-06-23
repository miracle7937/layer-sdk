import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for loading the checkbooks related to a customer.
class LoadCustomerCheckbooksUseCase {
  final CheckbookRepositoryInterface _repository;

  /// Creates a new [LoadCustomerCheckbooksUseCase].
  const LoadCustomerCheckbooksUseCase({
    required CheckbookRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a list of checkbooks related to the passed customer id.
  ///
  /// Use the [limit] and [offset] parameters for pagination purposes.
  /// If [descendingOrder] is true, the results will be returned in descending
  /// order.
  /// The [sortBy] is used for deciding which field will the results sorted by.
  Future<List<Checkbook>> call({
    required String customerId,
    int? limit,
    int? offset,
    bool forceRefresh = false,
    CheckbookSort? sortBy,
    bool descendingOrder = true,
  }) =>
      _repository.list(
        customerId: customerId,
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
      );
}
