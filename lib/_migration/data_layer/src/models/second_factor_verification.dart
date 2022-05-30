import 'package:equatable/equatable.dart';

/// A model that represents the second factor verification data.
class SecondFactorVerification extends Equatable {
  /// The identifier of the 2FA.
  final int? id;

  /// The type of the 2FA.
  final SecondFactorType type;

  /// The value to be used to verify the 2FA.
  final String? value;

  /// Creates [SecondFactorVerification].
  SecondFactorVerification({
    this.id,
    required this.type,
    this.value,
  });

  /// Returns a new instance with the provided value.
  SecondFactorVerification copyWith({
    required String value,
  }) =>
      SecondFactorVerification(
        id: id,
        type: type,
        value: value,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        value,
      ];
}

/// The type of the second factor authorization.
enum SecondFactorType {
  /// One time sms password.
  otp,

  /// Transaction pin
  pin,

  /// Hardware token
  hardwareToken,
}
