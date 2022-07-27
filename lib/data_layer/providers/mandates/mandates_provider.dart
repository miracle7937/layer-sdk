import '../../dtos.dart';
import '../../network.dart';

/// Provides data for Madates requests
class MadatesProvider {
  /// Handle network calls
  final NetClient netClient;

  /// Creates a new instance of [MadatesProvider]
  const MadatesProvider({required this.netClient});

  /// Returns a list of [MandateDTO]
  Future<List<MandateDTO>> listAllMandates({
    int? mandateId,
    int? limit,
    int? offset,
  }) async {
    final params = <String, dynamic>{
      'sort_by': 'ts_created',
    };

    if (mandateId != null) {
      params['mandate_id'] = mandateId;
    }

    if (limit != null) {
      params['limit'] = limit;
    }

    if (offset != null) {
      params['offset'] = offset;
    }

    final response = await netClient.request(
      netClient.netEndpoints.mandates,
      method: NetRequestMethods.get,
      queryParameters: params,
    );

    return MandateDTO.fromJsonList(response.data);
  }

  /// Cancels a mandate
  /// TODO - change the Future<void> if the return type is not just a 200
  Future<void> cancelMandate(int mandateId) async {
    final response = await netClient.request(
      "${netClient.netEndpoints.mandates}/$mandateId",
      method: NetRequestMethods.delete,
    );

    return response.data;
  }
}
