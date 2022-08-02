import '../../../../data_layer/network.dart';
import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the customers data
class CustomerRepository implements CustomerRepositoryInterface {
  final CustomerProvider _provider;

  /// Creates a new repository with the supplied [CustomerProvider]
  CustomerRepository(CustomerProvider provider) : _provider = provider;

  /// Lists the customers, optionally filtering them using [filters].
  ///
  /// Use [limit] and [offset] to paginate.
  ///
  /// The order is given by [sortBy] (which defaults to
  /// [CustomerSort.registered] and [descendingOrder], which defaults to `true`.
  @override
  Future<List<Customer>> list({
    CustomerType customerType = CustomerType.personal,
    CustomerFilters? filters,
    CustomerSort sortBy = CustomerSort.registered,
    bool descendingOrder = true,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    NetRequestCanceller? requestCanceller,
    String? id,
  }) async {
    filters = filters ?? CustomerFilters();

    final customerDTOs = await _provider.list(
      customerType: customerType.toCustomerDTOType(),
      id: id,
      name: filters.name,
      kycExpired: filters.kycExpired.toBoolean(),
      branchId: filters.branchIds.join(','),
      createdStart: filters.createdStart,
      createdEnd: filters.createdEnd,
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

  /// Fetches the current logged in customer
  @override
  Future<Customer> fetchCurrentCustomer() async {
    final customerDTOs = await _provider.fetchLoggedInCustomer();

    return customerDTOs.toCustomer(_customerCustomData);
  }

  /// Returns the id for the customer that owns the associated account id.
  @override
  Future<String> fetchIdFromAccountId({
    required String accountId,
    bool forceRefresh = false,
    NetRequestCanceller? requestCanceller,
  }) =>
      _provider.fetchIdFromAccountId(
        accountId: accountId,
        forceRefresh: forceRefresh,
        requestCanceller: requestCanceller,
      );

  /// Returns the id for the customer that owns the associated username.
  @override
  Future<String> fetchIdFromUsername({
    required String username,
    bool forceRefresh = true,
    NetRequestCanceller? requestCanceller,
  }) =>
      _provider.fetchIdFromUsername(
        username: username,
        forceRefresh: forceRefresh,
        requestCanceller: requestCanceller,
      );

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  ///
  /// Used by the DBO app only.
  @override
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
  @override
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
