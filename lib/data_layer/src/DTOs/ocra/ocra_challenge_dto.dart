/// A data transfer object representing the client OCRA challenge.
class OcraChallengeDTO {
  /// The device identifier.
  final int deviceId;

  /// The client challenge question.
  final String challenge;

  /// Creates a new [OcraChallengeDTO].
  const OcraChallengeDTO({
    required this.deviceId,
    required this.challenge,
  });

  /// Returns the json map.
  Map<String, dynamic> toJson() => {
        'device_id': deviceId,
        'client_challenge': challenge,
      };
}
