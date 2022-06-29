import '../../../../../data_layer/dtos.dart';
import '../../dtos.dart';

/// Data transfer object representing the data needed for registration.
class RegistrationDTO {
  /// An encrypted string containing any sensitive data that we need to send.
  String? encryptedCredentials;

  /// The language code.
  String? language;

  /// The referral identifier.
  String? referralId;

  /// The notification token.
  String? notificationToken;

  /// The device session information.
  DeviceSessionDTO? deviceSessionDTO;

  /// The public key used for encryption.
  String? encryptionKey;

  /// The customer id.
  ///
  /// It is needed when the registration endpoint is called to finalize
  /// the registration after calling the authentication endpoint.
  String? customerId;

  /// The OTP value.
  ///
  /// It only makes sense to pass the otp if the [customerId] is also passed.
  /// For regular registration flow the OTP should be verified
  /// with the [OTPProvider].
  String? otp;

  /// Creates [RegistrationDTO].
  RegistrationDTO({
    this.encryptedCredentials,
    this.language,
    this.referralId,
    this.notificationToken,
    this.deviceSessionDTO,
    this.encryptionKey,
    this.customerId,
    this.otp,
  });

  /// Returns a json map.
  Map<String, dynamic> toJson() {
    return {
      if (encryptedCredentials != null) 'credentials': encryptedCredentials,
      if (encryptionKey != null) 'key': encryptionKey,
      if (language != null) 'language': language,
      if (referralId != null) 'referral_id': referralId,
      if (notificationToken != null) 'notification_token': notificationToken,
      if (deviceSessionDTO != null) ...(deviceSessionDTO?.toJson() ?? {}),
      if (customerId != null) 'customer_id': customerId,
      if (otp != null) 'otp_value': otp,
    };
  }
}
