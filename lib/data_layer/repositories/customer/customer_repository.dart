import '../../../../data_layer/network.dart';
import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the customers data
class CustomerRepository implements CustomerRepositoryInterface {
  /// Customer provider
  final CustomerProvider provider;

  /// Creates a new repository with the supplied [CustomerProvider]
  CustomerRepository(this.provider);

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

    final customerDTOs = await provider.list(
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
  Future<Customer> fetchCurrentCustomer({
    bool forceRefresh = false,
  }) async {
    final customerDTOs = await provider.fetchLoggedInCustomer(
      forceRefresh: forceRefresh,
    );

    return customerDTOs.toCustomer(_customerCustomData);
  }

  /// Loads the limits of the customer.
  ///
  /// Returns `null` if the customer has no limits set.
  @override
  Future<CustomerLimit?> getCustomerLimits() async {
    final dto = await provider.getCustomerLimits();

    if (dto == null) return null;

    return dto.toCustomerLimit();
  }

  /// Loads the customer's image
  @override
  Future<dynamic> loadCustomerImage({
    required String imageURL,
  }) =>
      provider.loadCustomerImage(
        imageURL: imageURL,
      );

  DPAMappingCustomData get _customerCustomData => DPAMappingCustomData(
        token: provider.netClient.currentToken() ?? '',
        fileBaseURL: provider.customerDocumentsURLPrefix,
      );
}
