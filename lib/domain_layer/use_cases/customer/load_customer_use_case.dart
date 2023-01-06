import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../../../data_layer/network.dart';
import '../../../features/customer.dart';

/// Use case to load customers
class LoadCustomerUseCase {
  final CustomerRepositoryInterface _repository;
  final _log = Logger('CustomerRepository');

  /// Creates a new [LoadCustomerUseCase]
  LoadCustomerUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Lists the customers, optionally filtering them using [filters].
  ///
  /// Use [limit] and [offset] to paginate.
  ///
  /// The order is given by [sortBy] (which defaults to
  /// [CustomerSort.registered] and [descendingOrder], which defaults to `true`.
  Future<List<Customer>> call({
    CustomerType customerType = CustomerType.personal,
    CustomerFilters? filters,
    CustomerSort sortBy = CustomerSort.registered,
    bool descendingOrder = true,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    NetRequestCanceller? requestCanceller,
  }) async {
    final effectiveFilters = filters ?? CustomerFilters();

    // Both account id and username filtering depend on other endpoint calls
    // Here we get the customers ids from these filters if asked for.
    final extraIds = await Future.wait(
      [
        effectiveFilters.accountId.isEmpty
            ? Future.value(null)
            : _repository.fetchIdFromAccountId(
                accountId: effectiveFilters.accountId,
                forceRefresh: forceRefresh,
                requestCanceller: requestCanceller,
              ),
        effectiveFilters.username.isEmpty
            ? Future.value(null)
            : _repository.fetchIdFromUsername(
                username: effectiveFilters.username,
                forceRefresh: forceRefresh,
                requestCanceller: requestCanceller,
              ),
      ],
    );

    // If any of the customer ids is empty, it means no customer was found
    // with the given filters.
    if (extraIds.contains('')) {
      _log.info('Account ID and/or username returned no results.');

      return <Customer>[];
    }

    // Finally, we combine the customer id filter with the customer id gotten
    // from the optional account id and/or username.
    final ids = <String>{effectiveFilters.id}
      ..addAll(extraIds.whereNotNull())
      ..retainWhere((id) => id.isNotEmpty);

    // If there are more than one id listed, this means the filters are pointing
    // to different users, and thus we should return empty.
    if (ids.length > 1) {
      _log.info(
        'Filters id/accountId/username conflict. Returning empty list.',
      );

      return <Customer>[];
    }

    // If we got here, we're ready to list the customers
    return _repository.list(
      customerType: customerType,
      filters: filters,
      sortBy: sortBy,
      descendingOrder: descendingOrder,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
      requestCanceller: requestCanceller,
      id: ids.isNotEmpty ? ids.first : null,
    );
  }
}
