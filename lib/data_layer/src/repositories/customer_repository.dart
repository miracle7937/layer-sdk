import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../../models.dart';
import '../../network.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the customers data
class CustomerRepository {
  final _log = Logger('CustomerRepository');

  final CustomerProvider _provider;

  /// Creates a new repository with the supplied [CustomerProvider]
  CustomerRepository(CustomerProvider provider) : _provider = provider;

  /// Lists the customers, optionally filtering them using [filters].
  ///
  /// Use [limit] and [offset] to paginate.
  ///
  /// The order is given by [sortBy] (which defaults to
  /// [CustomerSort.registered] and [descendingOrder], which defaults to `true`.
  Future<List<Customer>> list({
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
            : _provider.fetchIdFromAccountId(
                accountId: effectiveFilters.accountId,
                forceRefresh: forceRefresh,
                requestCanceller: requestCanceller,
              ),
        effectiveFilters.username.isEmpty
            ? Future.value(null)
            : _provider.fetchIdFromUsername(
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
    final customerDTOs = await _provider.list(
      customerType: customerType.toCustomerDTOType(),
      id: ids.isNotEmpty ? ids.first : '',
      name: effectiveFilters.name,
      kycExpired: effectiveFilters.kycExpired.toBoolean(),
      branchId: effectiveFilters.branchIds.join(','),
      createdStart: effectiveFilters.createdStart,
      createdEnd: effectiveFilters.createdEnd,
      sortBy: sortBy.toFieldName(),
      descendingOrder: descendingOrder,
      limit: limit,
      offset: offset,
      forceRefresh: forceRefresh,
      requestCanceller: requestCanceller,
    );

    return customerDTOs
        .map((e) => e.toCustomer(_customerCustomData))
        .toList(growable: false);
  }

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  ///
  /// Used by the DBO app only.
  Future<bool> updateCustomerGracePeriod({
    required String customerId,
    required KYCGracePeriodType type,
    int? value,
  }) =>
      _provider.updateCustomerGracePeriod(
        customerId: customerId,
        type: type,
        value: value,
      );

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  ///
  /// Used by the DBO app only.
  Future<bool> updateCustomerEStatement({
    required String customerId,
    required bool value,
  }) =>
      _provider.updateCustomerEStatement(
        customerId: customerId,
        value: value,
      );

  DPAMappingCustomData get _customerCustomData => DPAMappingCustomData(
        token: _provider.netClient.currentToken() ?? '',
        fileBaseURL: _provider.customerDocumentsURLPrefix,
      );
}
