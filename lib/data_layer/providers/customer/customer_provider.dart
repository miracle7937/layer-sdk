import 'package:collection/collection.dart';

import '../../../../data_layer/network.dart';
import '../../dtos.dart';
import '../../environment.dart';

/// Provides data about the Customers
class CustomerProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [CustomerProvider] with the supplied netClient.
  CustomerProvider(
    this.netClient,
  );

  /// Returns a paginated list of sorted customers.
  ///
  /// Optionally filters the results by id, name, kyc status, branch ids and
  /// registered period.
  Future<List<CustomerDTO>> list({
    required String customerType,
    String? id,
    String? name,
    bool? kycExpired,
    String? branchId,
    DateTime? createdStart,
    DateTime? createdEnd,
    String? sortBy,
    bool descendingOrder = true,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    NetRequestCanceller? requestCanceller,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customer + (id?.isNotEmpty ?? false ? '/$id' : ''),
      method: NetRequestMethods.get,
      queryParameters: {
        'customer_type': customerType,
        if (name?.isNotEmpty ?? false) 'q': name,
        if (branchId?.isNotEmpty ?? false) 'branch_id': branchId,
        if (kycExpired != null) 'kyc_expired': kycExpired,
        if (createdStart != null) 'ts_from': createdStart,
        if (createdEnd != null) 'ts_to': createdEnd,
        if (sortBy?.isNotEmpty ?? false) 'sortby': sortBy,
        'desc': descendingOrder,
        'limit': limit,
        'offset': offset,
      },
      forceRefresh: forceRefresh,
      requestCanceller: requestCanceller,
      throwAllErrors: false,
    );

    if (!response.success || response.data == null) return [];

    if (response.data is List) {
      return CustomerDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data),
      );
    }

    return [
      CustomerDTO.fromJson(response.data),
    ];
  }

  /// Returns the customer DTO
  Future<CustomerDTO> fetchLoggedInCustomer({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customer,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
      throwAllErrors: true,
    );

    return CustomerDTO.fromJson(
      response.data is List ? response.data.first : response.data,
    );
  }

  /// Returns the id for the customer that owns the associated account id.
  Future<String> fetchIdFromAccountId({
    required String accountId,
    bool forceRefresh = false,
    NetRequestCanceller? requestCanceller,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.customerAccount,
      queryParameters: {
        'account_no': accountId,
      },
      forceRefresh: forceRefresh,
      requestCanceller: requestCanceller,
    );

    final data = response.data;

    if (response.success && data is List && data.isNotEmpty) {
      return AccountDTO.fromJson(response.data[0]).customerId ?? '';
    }

    return '';
  }

  /// Returns the id for the customer that owns the associated username.
  Future<String> fetchIdFromUsername({
    required String username,
    bool forceRefresh = true,
    NetRequestCanceller? requestCanceller,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.user,
      queryParameters: {
        'username': username,
      },
      forceRefresh: forceRefresh,
      requestCanceller: requestCanceller,
      throwAllErrors: false,
    );

    final data = response.data;

    if (response.success && data is List && data.isNotEmpty) {
      return UserDTO.fromJson(response.data[0]).customerId ?? '';
    }

    return '';
  }

  /// Returns the data of a customer.
  Future<CustomerDTO> customer({
    required String customerId,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.customer}/$customerId',
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return CustomerDTO.fromJson(response.data);
  }

  /// Returns the customer data for all the customers ids on the given list.
  Future<List<CustomerDTO>> customers({
    required List<String> customerIds,
    bool forceRefresh = false,
  }) async {
    // TODO: ask the backend for one method to return all this in one go.
    final responses = await Future.wait<NetResponse?>(
      List.generate(
        customerIds.length,
        (i) async {
          try {
            final response = await netClient.request(
              '${netClient.netEndpoints.customer}/${customerIds[i]}',
              method: NetRequestMethods.get,
              forceRefresh: forceRefresh,
            );
            return response;
          } on Exception {
            return null;
          }
        },
      ),
    );

    return responses
        .whereNotNull()
        .map((e) => CustomerDTO.fromJson(e.data))
        .toList();
  }

  /// Loads the limits of the customer.
  ///
  /// Returns `null` if the customer has no limits set.
  Future<CustomerLimitDTO?> getCustomerLimits() async {
    final response = await netClient.request(
      netClient.netEndpoints.customerLimits,
      queryParameters: {
        'module': 'all',
      },
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      final isEmpty = data['total_limits']?.isEmpty ?? true;

      return isEmpty ? null : CustomerLimitDTO.fromJson(data);
    }

    return null;
  }

  /// Returns the prefix URL to access files on the server.
  String get customerDocumentsURLPrefix =>
      '${EnvironmentConfiguration.current.baseUrl}'
      '${netClient.netEndpoints.automationLink}';
}
