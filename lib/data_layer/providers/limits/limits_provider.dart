import '../../dtos.dart';
import '../../network.dart';

///Provides data about limits
class LimitsProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [LimitsProvider] with the supplied netClient.
  LimitsProvider({
    required this.netClient,
  });

  /// Returns limits with provided [customerId] or [agentId].
  ///
  /// Can be used by [Customer]'s or [Agent]'s
  Future<LimitsDTO> load({
    String? customerId,
    String? agentId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
  }) async {
    final data = await Future.wait([
      netClient.request(
        netClient.netEndpoints.transferLimits,
        method: NetRequestMethods.get,
        forceRefresh: forceRefresh,
        queryParameters: {
          'txn_limit.limit_id':
              customerId != null ? 'customer_$customerId' : 'agent_$agentId',
          if (offset != null) 'offset': offset,
          if (limit != null) 'limit': limit,
        },
      ),
      netClient.request(
        netClient.netEndpoints.transferLimits,
        method: NetRequestMethods.get,
        forceRefresh: forceRefresh,
        queryParameters: {
          'txn_limit.limit_id':
              customerId != null ? 'customer_$customerId' : 'agent_$agentId',
          if (offset != null) 'offset': offset,
          if (limit != null) 'limit': limit,
        },
      )
    ]);
    final response = data[0];
    final responseDefined = data[1];
    if (response.data is List && response.data.length > 0) {
      final limitsDTO = LimitsDTO.fromJson(response.data[0]);
      if (responseDefined.data is List && responseDefined.data.length > 0) {
        final limitsDTODefined = LimitsDTO.fromJson(responseDefined.data[0]);
        limitsDTO.limCumulativeDaily = limitsDTODefined.limCumulativeDaily;
      }
      return limitsDTO;
    }

    throw Exception('Limits not found');
  }

  /// Saves provided [limitsDTO] limits information.
  /// Parameter [edit] should be true on on edit, while post in for creating a
  ///  new limit.
  ///
  /// Can be used by [Customer]'s or [Agent]'s
  Future<QueueDTO> save({
    String? customerId,
    String? agentId,
    required String customerType,
    required LimitsDTO limitsDTO,
    bool edit = true,
  }) async {
    final customerJson = limitsDTO.toCustomerJson()
      ..addAll({
        'limit_id':
            customerId != null ? 'customer_$customerId' : 'agent_$agentId'
      });
    final customerDefinedJson = limitsDTO.toCustomerDefinedJson()
      ..addAll({'limit_id': 'customerdefined_$customerId'});

    final response = await netClient.request(
      netClient.netEndpoints.transferLimits,
      method: edit ? NetRequestMethods.put : NetRequestMethods.post,
      data: [customerJson, customerDefinedJson],
      queryParameters: {
        'customer_type': customerType,
      },
    );

    if (response.data is List && response.data.length > 0) {
      return QueueDTO.fromJson(response.data[0]);
    }

    throw Exception('Limits not being saved');
  }
}
