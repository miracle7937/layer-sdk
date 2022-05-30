/// Holds the card type information as
/// provided by the infobanking service
class CardTypeDTO {
  /// The category of this card
  /// 0 - Debit
  /// 1 - Credit
  /// 2 - Prepaid
  num? cardCategory;

  /// Type name of the card
  String? type;

  /// Creates a new [CardTypeDTO]
  CardTypeDTO({
    this.cardCategory,
    this.type,
  });

  /// Creates a [CardTypeDTO] from a JSON
  factory CardTypeDTO.fromJson(Map<String, dynamic> map) {
    return CardTypeDTO(
      cardCategory: map['category'],
      type: map['type'],
    );
  }
}
