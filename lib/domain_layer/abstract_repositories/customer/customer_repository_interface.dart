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

  /// Returns the id for the customer that owns the associated account id.
  Future<String> fetchIdFromAccountId({
    required String accountId,
    bool forceRefresh = false,
    NetRequestCanceller? requestCanceller,
  });

  /// Returns the id for the customer that owns the associated username.
  Future<String> fetchIdFromUsername({
    required String username,
    bool forceRefresh = true,
    NetRequestCanceller? requestCanceller,
  });

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  ///
  /// Used by the DBO app only.
  Future<bool> updateCustomerGracePeriod({
    required String customerId,
    required KYCGracePeriodType type,
    int? value,
  });

  /// Updates the customer KYC grace period based on the provided
  /// parameters.
  ///
  /// Used by the DBO app only.
  Future<bool> updateCustomerEStatement({
    required String customerId,
    required bool value,
  });

  /// Returns the customer associated with the provided `customerId`.
  Future<Customer> getCustomer({
    required String customerId,
    bool forceRefresh = false,
  });

  /// Forces update of the user and customer associated to the
  /// provided `customerId`.
  ///
  /// Returns whether or not the request was successfull.
  Future<bool> forceCustomerUpdate({
    required String customerId,
  });

  /// Loads the limits of the customer.
  ///
  /// Returns `null` if the customer has no limits set.
  Future<CustomerLimit?> getCustomerLimits();
}
