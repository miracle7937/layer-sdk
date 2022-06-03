import 'package:equatable/equatable.dart';

///The reward type
enum RewardType {
  ///Discount
  discount,

  ///Cashback
  cashback,

  ///Points
  points,
}

///The reward schedule
enum RewardSchedule {
  ///Now (as soon as they're eligible for the reward)
  now,

  ///End of month
  endOfMonth,

  ///End of quarter
  endOfQuarter,

  ///End of year
  endOfYear,
}

///Contains the data of a reward for a rule
class RuleReward extends Equatable {
  ///The reward id
  final int? id;

  ///The reward type
  final RewardType? type;

  ///The amount for this reward
  final double? amount;

  ///The percentage of cashback for this reward
  final double? percentage;

  ///The reward can be redeemed immediately when the criteria is met
  ///or it's scheduled
  final RewardSchedule schedule;

  ///Creates a new [RuleReward]
  RuleReward({
    this.id,
    this.type,
    this.amount,
    this.percentage,
    required this.schedule,
  });

  ///Creates a copy of this rule reward with different values
  RuleReward copyWith({
    int? id,
    RewardType? type,
    double? amount,
    double? percentage,
    RewardSchedule? schedule,
  }) =>
      RuleReward(
        id: id ?? this.id,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        percentage: percentage ?? this.percentage,
        schedule: schedule ?? this.schedule,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        amount,
        percentage,
        schedule,
      ];
}
