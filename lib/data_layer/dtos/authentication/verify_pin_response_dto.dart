import '../../helpers.dart';
import '../../network.dart';

/// A data transfer object representing the verify pin response
class VerifyPinResponseDTO {
  /// Whether the pin verification was successful or not
  bool? isVerified;

  /// The remaining attempts for the current pin verification
  int? remainingAttempts;

  /// Creates a new [VerifyPinResponseDTO]
  VerifyPinResponseDTO({
    this.isVerified,
    this.remainingAttempts,
  });

  /// Creates an [VerifyPinResponseDTO] from the supplied [NetResponse].
  VerifyPinResponseDTO.fromJson(NetResponse response)
      : isVerified = response.success,
        remainingAttempts = response.data['fields'] == null
            ? null
            : JsonParser.parseInt(
                response.data['fields']['remaining_attempts']);
}
