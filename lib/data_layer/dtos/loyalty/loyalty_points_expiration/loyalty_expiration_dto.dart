/// Hold loyalty points that will expire till a given date
class LoyaltyPointsExpirationDTO {
  /// Amount of points
  int? amount;

  /// Creates a new [LoyaltyPointsExpirationDTO] instance
  LoyaltyPointsExpirationDTO({
    this.amount,
  });

  /// Creates a new [LoyaltyPointsExpirationDTO] from a json map
  factory LoyaltyPointsExpirationDTO.fromJson(Map<String, dynamic> json) =>
      LoyaltyPointsExpirationDTO(
        amount: json['amount'],
      );
}
