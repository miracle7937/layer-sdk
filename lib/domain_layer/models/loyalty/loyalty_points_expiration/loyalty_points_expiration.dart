import 'package:equatable/equatable.dart';

///Holds expired loyalty points
class LoyaltyPointsExpiration extends Equatable {
  ///Amount of points
  final int amount;

  ///Creates a [LoyaltyPointsExpiration] object
  const LoyaltyPointsExpiration({
    required this.amount,
  });

  ///Clone and return a new [LoyaltyPointsExpiration] object
  LoyaltyPointsExpiration copyWith({
    int? amount,
  }) =>
      LoyaltyPointsExpiration(
        amount: amount ?? this.amount,
      );

  @override
  List<Object?> get props => [
        amount,
      ];
}
