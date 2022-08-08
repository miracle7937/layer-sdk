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
      'sortby': 'ts_created',
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

    return MandateDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Cancels a mandate
  Future<SecondFactorTypeDTO?> cancelMandate({
    required int mandateId,
    String? otpValue,
    SecondFactorTypeDTO? otpType,
  }) async {
    final response = await netClient.request(
      "${netClient.netEndpoints.mandates}/$mandateId",
      method: NetRequestMethods.delete,
      data: otpValue != null && otpType != null
          ? {
              otpType.value.toLowerCase(): otpValue,
            }
          : null,
    );

    if (response.data?.isEmpty ?? true) return null;

    return SecondFactorTypeDTO.fromRaw(response.data['second_factor'] ?? '');
  }
}
