/// A data transfer object representing the response to the client OCRA
/// challenge.
class OcraChallengeResponseDTO {
  /// The result of the client OCRA challenge sent to the API.
  final String? serverResponse;

  /// An OCRA challenge to be solved by the client.
  final String? serverChallenge;

  /// Creates new [OcraChallengeResponseDTO] from a json map.
  OcraChallengeResponseDTO.fromJson(Map<String, dynamic> json)
      : serverResponse = json['server_response'],
        serverChallenge = json['server_challenge'];
}
