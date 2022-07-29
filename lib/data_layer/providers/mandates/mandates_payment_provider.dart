import '../../dtos.dart';
import '../../extensions/map/map_extensions.dart';
import '../../network.dart';

/// Provides data for MandatePayments
class MandatePaymentsProvider {
  /// Handle network requests
  final NetClient netClient;

  /// Creates a new [MandatePaymentsProvider]
  MandatePaymentsProvider({
    required this.netClient,
  });

  /// Fetches a list of [MandatePayment]
  Future<List<MandatePaymentDTO>> fetchMandatePayments({
    int? limit,
    int? offset,
    String? sortBy,

    /// If the sort is descending or not
    bool desc = false,
  }) async {
    final params = <String, dynamic>{}
      ..addIfNotNull('limit', limit)
      ..addIfNotNull('offset', offset);

    if (sortBy?.isNotEmpty ?? false) {
      params['sortBy'] = sortBy;
      params['desc'] = desc;
    }

    final response = await netClient.request(
      netClient.netEndpoints.mandatePayments,
      method: NetRequestMethods.get,
      queryParameters: params,
    );

    return MandatePaymentDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
