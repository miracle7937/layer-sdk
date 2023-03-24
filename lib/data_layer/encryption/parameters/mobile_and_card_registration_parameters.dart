import '../../../../../domain_layer/models.dart';
import '../../encryption.dart';

/// The parameters to be used in registration flows that require customer
/// to input his card details and mobile number.
class MobileAndCardRegistrationParameters extends RegistrationParameters {
  /// The customers mobile number.
  final String? mobileNumber;

  /// The the customers card number.
  final String? cardNumber;

  /// The expiry date of the customers credit card.
  ///
  /// Should be in the following format: "MM/YY".
  final String? expiryDate;

  /// The customers card verification code.
  final String? cvv;

  /// Creates [MobileAndCardRegistrationParameters].
  MobileAndCardRegistrationParameters({
    String? notificationToken,
    DeviceSession? deviceSession,
    this.mobileNumber,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
  }) : super(
          notificationToken: notificationToken,
          deviceSession: deviceSession,
        );

  /// Returns a copy modified by provided values.
  MobileAndCardRegistrationParameters copyWith({
    String? notificationToken,
    DeviceSession? deviceSession,
    String? mobileNumber,
    String? cardNumber,
    String? expiryDate,
    String? cvv,
  }) =>
      MobileAndCardRegistrationParameters(
        notificationToken: notificationToken ?? this.notificationToken,
        deviceSession: deviceSession ?? this.deviceSession,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        cardNumber: cardNumber ?? this.cardNumber,
        expiryDate: expiryDate ?? this.expiryDate,
        cvv: cvv ?? this.cvv,
      );

  @override
  List<Object?> get props => [
        notificationToken,
        deviceSession,
        mobileNumber,
        cardNumber,
        expiryDate,
        cvv,
      ];
}
