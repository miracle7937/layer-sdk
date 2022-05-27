import '../dtos.dart';

/// Data transfer object representing the response received from the API
/// after trying to log in using the branch activation feature.
class BranchActivationResponseDTO {
  /// The user token.
  String? token;

  /// The identifier of the OTP.
  int? otpId;

  /// The type of the 2FA to be used.
  SecondFactorDTO? secondFactor;

  /// The device id;
  int? deviceId;

  /// The secret key to be used in the OCRA mutual authentication flow.
  String? ocraSecret;

  /// Creates [BranchActivationResponseDTO] from a json map.
  BranchActivationResponseDTO.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    otpId = json['otp_id'];
    secondFactor = SecondFactorDTO.fromRaw(json['second_factor']);
    deviceId = json['device_id'];
    ocraSecret = json['ocra_key'];
  }
}
