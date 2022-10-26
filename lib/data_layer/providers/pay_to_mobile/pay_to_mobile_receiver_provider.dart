import '../../dtos.dart';
import '../../extensions/map/map_extensions.dart';
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
  Future<void> postReceivedTransfer({
    required String fromSendMoneyId,
    required String accountId,
    required String withdrawalCode,
    required String withdrawalPin,
    required String deviceUUID,
    String? reason,
    BeneficiaryDTO? beneficiary,
  }) async {
    final data = <String, Object>{
      'from_send_money_id': fromSendMoneyId,
      'to_account_id': accountId,
      'device_uid': deviceUUID,
      'withdrawal_code': withdrawalCode,
      'withdrawal_pin': withdrawalPin,
    };
    data.addIfNotNull('reason', reason);
    data.addIfNotNull('beneficiary', beneficiary?.toJson());

    await _netClient.request(
      _netClient.netEndpoints.transferV2,
      method: NetRequestMethods.post,
      data: data,
    );
  }
}
