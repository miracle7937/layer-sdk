/// Hold points that will expire till a given date
class LoyaltyExpirationDTO {
  /// Amount of points
  int? amount;

  /// Creates a new [LoyaltyExpirationDTO] instance
  LoyaltyExpirationDTO({
    this.amount,
  });

  /// Creates a new [LoyaltyExpirationDTO] from a json map
  factory LoyaltyExpirationDTO.fromJson(Map<String, dynamic> json) {
    return LoyaltyExpirationDTO(
      amount: json['amount'],
    );
  }
}
