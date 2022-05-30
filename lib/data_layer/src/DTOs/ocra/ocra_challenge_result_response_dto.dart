/// A data transfer object representing the response to the challenge result.
class OcraChallengeResultResponseDTO {
  /// The customer access token.
  final String? token;

  /// The remaining attempts before the device is deactivated.
  final int? remainingAttempts;

  /// Creates new [OcraChallengeResultResponseDTO] from a json map.
  OcraChallengeResultResponseDTO.fromJson(
    Map<String, dynamic> json,
  )   : token = json['token'],
        remainingAttempts = json['fields'] != null
            ? json['fields']['remaining_attempts']
            : null;
}
