///Holds de expiration points
class LoyaltyExpiration {
  ///Amount of points
  final int amount;

  ///Creates a [LoyaltyExpiration] object
  const LoyaltyExpiration({
    required this.amount,
  });

  ///Clone and return a new [LoyaltyExpiration] object
  LoyaltyExpiration copyWith({
    int? amount,
  }) {
    return LoyaltyExpiration(
      amount: amount ?? this.amount,
    );
  }
}
