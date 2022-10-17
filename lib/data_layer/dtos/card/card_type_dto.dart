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

  /// If the user can stop card
  bool? canStopCard;

  /// If the user can freeze card
  bool? canFreezeCard;

  /// The customer's card image
  String? image;

  /// Creates a new [CardTypeDTO]
  CardTypeDTO({
    this.cardCategory,
    this.type,
    this.canStopCard,
    this.canFreezeCard,
    this.image,
  });

  /// Creates a [CardTypeDTO] from a JSON
  factory CardTypeDTO.fromJson(Map<String, dynamic> map) {
    return CardTypeDTO(
      cardCategory: map['category'],
      type: map['type'],
      canStopCard: map['can_stop_card'] ?? true,
      canFreezeCard: map['can_freeze_card'] ?? true,
      image: map['image_url'],
    );
  }
}
