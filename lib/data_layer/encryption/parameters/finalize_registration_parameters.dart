import '../../../../../domain_layer/models.dart';
import '../../encryption.dart';

/// A class representing parameters for finalizing
/// the registration/authentication flow.
class FinalizeRegistrationParameters extends RegistrationParameters {
  /// The id of the customer.
  final String customerId;

  /// The value of the OTP.
  final String? otp;

  /// An encrypted string containing any sensitive data that we need to send.
  final String encryptedCredentials;

  /// The public key used for encryption.
  final String encryptionKey;

  /// Creates [FinalizeRegistrationParameters].
  FinalizeRegistrationParameters({
    required this.customerId,
    required this.encryptedCredentials,
    required this.encryptionKey,
    this.otp,
    String? notificationToken,
    DeviceSession? deviceSession,
  }) : super(
          notificationToken: notificationToken,
          deviceSession: deviceSession,
        );

  /// Creates a new instance of [FinalizeRegistrationParameters]
  /// based on this one.
  FinalizeRegistrationParameters copyWith({
    String? customerId,
    String? encryptedCredentials,
    String? encryptionKey,
    String? otp,
    String? notificationToken,
    DeviceSession? deviceSession,
  }) =>
      FinalizeRegistrationParameters(
        customerId: customerId ?? this.customerId,
        encryptedCredentials: encryptedCredentials ?? this.encryptedCredentials,
        encryptionKey: encryptionKey ?? this.encryptionKey,
        otp: otp ?? this.otp,
        notificationToken: notificationToken ?? this.notificationToken,
        deviceSession: deviceSession ?? this.deviceSession,
      );

  @override
  List<Object?> get props => [
        notificationToken,
        deviceSession,
        customerId,
        otp,
        encryptedCredentials,
        encryptionKey,
      ];
}
