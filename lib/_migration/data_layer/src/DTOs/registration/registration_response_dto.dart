import '../../dtos.dart';

/// Data transfer object representing the response received from the API
/// after registering the customer.
class RegistrationResponseDTO {
  /// The integration public key used for data encryption
  String? key;

  /// The authorization token for registration
  String? token;

  /// The identifier of the customer.
  String? customerId;

  /// The identifier of the OTP.
  int? otpId;

  /// The mobile number of the customer.
  String? mobileNumber;

  /// The masked mobile number of the customer.
  String? maskedMobileNumber;

  /// The type of the 2FA to be used.
  SecondFactorDTO? secondFactor;

  /// The first name of the customer.
  String? firstName;

  /// The last name of the customer.
  String? lastName;

  /// True if this is the first time that customer registers.
  bool? firstTimeRegistration;

  /// The id expiry date
  String? idExpiryDate;

  /// The kyc expiry date
  String? kycExpiryDate;

  /// The warning
  String? warning;

  /// The warning message
  String? warningMessage;

  /// The device id;
  int? deviceId;

  /// The secret key to be used in the OCRA mutual authentication flow.
  String? ocraSecret;

  /// Creates [RegistrationResponseDTO] from a json map.
  RegistrationResponseDTO.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    token = json['jwt'];
    customerId = json['customer_id'];
    otpId = json['otp_id'];
    mobileNumber = json['mobile_number'];
    maskedMobileNumber = json['masked_mobile_number'];
    secondFactor = SecondFactorDTO.fromRaw(json['second_factor']);
    firstName = json['first_name'];
    lastName = json['last_name'];
    firstTimeRegistration = json["first_time"] ?? false;
    idExpiryDate = json["id_expiry"];
    kycExpiryDate = json["kyc_expiry"];
    warning = json["warning"];
    warningMessage = json["warning_message"];
    deviceId = json['device_id'];
    ocraSecret = json['ocra_key'];
  }
}
