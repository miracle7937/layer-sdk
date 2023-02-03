import '../../../../data_layer/network.dart';
import '../../dtos.dart';

/// Provides data about customer's bills
class BillProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [BillProvider] with the supplied [NetClient].
  BillProvider({
    required this.netClient,
  });

  /// Validates the provided bill
  Future<BillDTO> validateBill({
    required BillDTO bill,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.validateBill,
      method: NetRequestMethods.post,
      data: bill.toJson(),
      forceRefresh: true,
    );

    return BillDTO.fromJson(response.data);
  }
}
