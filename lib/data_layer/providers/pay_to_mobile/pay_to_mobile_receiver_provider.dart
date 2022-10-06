import '../../dtos.dart';
import '../../extensions/map/map_extensions.dart';
import '../../helpers.dart';
import '../../network.dart';

/// Provider for handling
class PayToMobileReceiverProvider {
  /// The NetClient to use for the network requests
  final NetClient _netClient;

  /// Creates a new [PayToMobileReceiverProvider]
  PayToMobileReceiverProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// Posts a received mobile payment
  Future<SecondFactorTypeDTO?> postReceivedTransfer({
    required String fromSendMoneyId,
    required String accountId,
    required String withdrawalCode,
    required String withdrawalPin,
    String? reason,
    BeneficiaryDTO? beneficiary,
  }) async {
    final data = <String, Object>{
      'from_send_money_id': fromSendMoneyId,
      'to_account_id': accountId,
      'device_uid': randomAlphaNumeric(30),
      'withdrawal_code': withdrawalCode,
      'withdrawal_pin': withdrawalPin,
    };
    data.addIfNotNull('reason', reason);
    data.addIfNotNull('beneficiary', beneficiary?.toJson());

    final response = await _netClient.request(
      _netClient.netEndpoints.transferV2,
      method: NetRequestMethods.post,
      data: data,
    );

    final secFactor = response.data?['second_factor'] as String;
    return SecondFactorTypeDTO.fromRaw(secFactor);
  }
}
