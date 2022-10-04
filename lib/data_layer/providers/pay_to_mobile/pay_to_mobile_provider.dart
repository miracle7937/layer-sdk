import '../../dtos/pay_to_mobile/new_pay_to_mobile_dto.dart';
import '../../dtos/pay_to_mobile/pay_to_mobile_dto.dart';
import '../../network.dart';

/// Provider that handles the data for the pay to mobile flow.
class PayToMobileProvider {
  /// The NetClient to use for the network requests.
  final NetClient _netClient;

  /// Creates [PayToMobileProvider].
  PayToMobileProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// Submits a new pay to mobile flow and returns a pay to mobile dto element.
  Future<PayToMobileDTO> submit({
    required NewPayToMobileDTO newPayToMobileDTO,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.sendMoney,
      method: NetRequestMethods.post,
      data: newPayToMobileDTO.toJson(),
    );

    return PayToMobileDTO.fromJson(response.data);
  }
}
