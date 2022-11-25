import 'dart:async';

import '../../../../data_layer/network.dart';

/// Provides data for the Meawallet plugin.
class MeawalletProvider {
  /// NetClient used for network requests
  final NetClient _netClient;

  /// Creates a new [MeawalletProvider] instance
  MeawalletProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// Returns Meawallet OTOP secret for the passed [cardToken].
  Future<String> getSecretFromCardToken({
    required String cardToken,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.meawalletTOTP,
      method: NetRequestMethods.post,
      data: {'card_token': cardToken},
    );

    return response.data['secret'];
  }
}
