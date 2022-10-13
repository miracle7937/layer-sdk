import '../second_factor/second_factor_type_dto.dart';

/// Represents the customers card info
class CardInfoDTO {
  /// The card pin
  String? cardPin;

  /// The card expiry date
  String? expiryDate;

  /// The unmasked card number
  String? unmaskedCardNumber;

  /// The otp ID
  int? otpId;

  /// The second factor type
  SecondFactorTypeDTO? secondFactorType;

  /// Creates a new [CardDTO]
  CardInfoDTO({
    this.cardPin,
    this.expiryDate,
    this.unmaskedCardNumber,
    this.otpId,
    this.secondFactorType,
  });

  /// Creates a [CardInfoDTO] from a JSON
  factory CardInfoDTO.fromJson(Map<String, dynamic> map) {
    return CardInfoDTO(
      cardPin: map['pin'],
      expiryDate: map['expiry'],
      unmaskedCardNumber: map['card_no'],
      otpId: map['otp_id'],
      secondFactorType: SecondFactorTypeDTO.fromRaw(map['second_factor']),
    );
  }

  /// Creates a list of [CardInfoDTO] from a JSON list
  static List<CardInfoDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(CardInfoDTO.fromJson).toList(growable: false);
}
