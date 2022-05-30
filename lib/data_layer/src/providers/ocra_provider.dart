import '../../../migration/data_layer/network.dart';
import '../dtos.dart';

/// A provider that handles the API requests related to OCRA challenges.
class OcraProvider {
  /// The [NetClient] to be used for API requests.
  final NetClient netClient;

  /// Creates
  const OcraProvider({
    required this.netClient,
  });

  /// Posts a client challenge to the API. Returns the result of the client
  /// challenge alongside the server challenge.
  Future<OcraChallengeResponseDTO> challenge({
    required OcraChallengeDTO challenge,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.ocraChallenge,
      method: NetRequestMethods.post,
      data: challenge.toJson(),
      useDefaultToken: true,
      forceRefresh: forceRefresh,
    );

    return OcraChallengeResponseDTO.fromJson(response.data);
  }

  /// Posts the result to the server challenge to the API. Returns a new token
  /// if the result verification is successful.
  Future<OcraChallengeResultResponseDTO> verifyResult({
    required OcraChallengeResultDTO result,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.ocraResult,
      method: NetRequestMethods.post,
      data: result.toJson(),
      useDefaultToken: true,
      throwAllErrors: false,
      forceRefresh: forceRefresh,
    );

    return OcraChallengeResultResponseDTO.fromJson(response.data);
  }
}
