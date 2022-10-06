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

  /// Creates a new immutable [CardInfo]
  CardInfo({
    this.otpId,
    this.secondFactorType,
    required this.cardPin,
    required this.expiryDate,
    required this.unmaskedCardNumber,
  });

  @override
  List<Object?> get props => [
        otpId,
        secondFactorType,
        cardPin,
        expiryDate,
        unmaskedCardNumber,
      ];
}
