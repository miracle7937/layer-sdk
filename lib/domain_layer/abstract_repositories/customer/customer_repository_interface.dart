import '../../../data_layer/network.dart';
import '../../models.dart';

/// Abstract repository that handles customer data
abstract class CustomerRepositoryInterface {
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
    String? id,
  });

  /// Fetches the logged in customer
  Future<Customer> fetchCurrentCustomer({
    bool forceRefresh = false,
  });

  /// Loads the limits of the customer.
  ///
  /// Returns `null` if the customer has no limits set.
  Future<CustomerLimit?> getCustomerLimits();

  /// Loads the customer's image
  Future<dynamic> loadCustomerImage({
    required String imageURL,
  });
}
