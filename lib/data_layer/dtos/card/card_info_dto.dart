import '../second_factor/second_factor_type_dto.dart';

/// Represents the infor for a banking card.
class CardInfoDTO {
  /// The card pin
  String? cardPin;

  /// The card expiry date
  DateTime? expiryDate;

  /// The unmasked card number
  String? unmaskedCardNumber;

  /// The otp ID
  int? otpId;

  /// The second factor type
  SecondFactorTypeDTO? secondFactorType;

  /// Creates a new [CardInfoDTO].
  CardInfoDTO({
    this.cardPin,
    this.expiryDate,
    this.unmaskedCardNumber,
    this.otpId,
    this.secondFactorType,
  });

  /// Creates a [CardInfoDTO] from a JSON
  factory CardInfoDTO.fromJson(Map<String, dynamic> json) {
    final splittedExpiry = (json['expiry'] ?? '')
        .toString()
        .split('-')
        .map(
          int.tryParse,
        )
        .toList();

    return CardInfoDTO(
      cardPin: json['pin'],
      expiryDate: splittedExpiry.isEmpty ||
              splittedExpiry.length != 3 ||
              splittedExpiry.contains(null)
          ? null
          : DateTime(
              splittedExpiry.last!,
              splittedExpiry[1]!,
              splittedExpiry.first!,
            ),
      unmaskedCardNumber: json['card_no'],
      otpId: json['otp_id'],
      secondFactorType: SecondFactorTypeDTO.fromRaw(json['second_factor']),
    );
  }

  /// Creates a list of [CardInfoDTO] from a JSON list
  static List<CardInfoDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(CardInfoDTO.fromJson).toList(growable: false);
}
