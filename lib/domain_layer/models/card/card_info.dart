import 'package:equatable/equatable.dart';

import '../second_factor/second_factor_type.dart';

/// The card info
class CardInfo extends Equatable {
  /// Second factor otp id
  final int? otpId;

  /// Second factor type
  final SecondFactorType? secondFactorType;

  /// The card pin
  final String? cardPin;

  /// The card expiry date
  final String? expiryDate;

  /// The unmasked card number
  final String? unmaskedCardNumber;

  /// The cvv number.
  final String? cvv;

  /// Creates a new immutable [CardInfo]
  CardInfo({
    this.otpId,
    this.secondFactorType,
    this.cardPin,
    this.expiryDate,
    this.unmaskedCardNumber,
    this.cvv,
  });

  /// Creates a copy with the passed values.
  CardInfo copyWith({
    int? otpId,
    SecondFactorType? secondFactorType,
    String? cardPin,
    String? expiryDate,
    String? unmaskedCardNumber,
    String? cvv,
  }) =>
      CardInfo(
        otpId: otpId ?? this.otpId,
        secondFactorType: secondFactorType ?? this.secondFactorType,
        cardPin: cardPin ?? this.cardPin,
        expiryDate: expiryDate ?? this.expiryDate,
        unmaskedCardNumber: unmaskedCardNumber ?? this.unmaskedCardNumber,
        cvv: cvv ?? this.cvv,
      );

  @override
  List<Object?> get props => [
        otpId,
        secondFactorType,
        cardPin,
        expiryDate,
        unmaskedCardNumber,
        cvv,
      ];
}
