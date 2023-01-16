import '../../network.dart';

/// A provider that handles API requests related to validations.
class ValidatorProvider {
  final NetClient _netClient;

  /// Creates a new [ValidatorProvider]
  ValidatorProvider({
    required NetClient netClient,
  }) : _netClient = netClient;

  /// Validate the transaction pin by `txnPin`
  Future<void> validateTransactionPin({
    required String txnPin,
    required String userId,
  }) {
    final response = _netClient.request(
      '${_netClient.netEndpoints.validateTransactionPin}/$userId/check',
      method: NetRequestMethods.post,
      data: {
        'pin': txnPin,
      },
    );

    return response;
  }
}
