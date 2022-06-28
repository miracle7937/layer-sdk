/// A data transfer object representing a result of the server OCRA challenge.
class OcraChallengeResultDTO {
  /// The device identifier.
  final int deviceId;

  /// The solved result to the OCRA challenge received from the server.
  final String result;

  /// Creates new [OcraChallengeResultDTO].
  OcraChallengeResultDTO({
    required this.deviceId,
    required this.result,
  });

  /// Returns the json map.
  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'client_response': result,
      };
}
