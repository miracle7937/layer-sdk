import 'package:collection/collection.dart';

import '../../../helpers.dart';

///Data transfer object representing a reward for an offer rule
class RuleRewardDTO {
  ///The reward id
  int? id;

  ///The reward type
  RewardTypeDTO? type;

  ///The amount for this reward
  double? amount;

  ///The perentage of cashback for this reward
  double? percentage;

  ///The reward can be redeemed inmediately when the criteria is met
  ///or it's scheduled
  RewardScheduleDTO? schedule;

  ///Creates a new [RuleRewardDTO]
  RuleRewardDTO({
    this.id,
    this.type,
    this.amount,
    this.percentage,
    this.schedule,
  });

  ///Creates a [RuleRewardDTO] form a JSON object
  factory RuleRewardDTO.fromJson(Map<String, dynamic> json) => RuleRewardDTO(
        id: JsonParser.parseInt(json['reward_id']),
        type: RewardTypeDTO.fromRaw(json['type']),
        amount: JsonParser.parseDouble(json['amount']),
        percentage: JsonParser.parseDouble(json['percentage']),
        schedule: RewardScheduleDTO.fromRaw(json['scheduled']),
      );

  /// Creates a list of [RuleRewardDTO]s from the given JSON list.
  static List<RuleRewardDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(RuleRewardDTO.fromJson).toList();
}

///Data transfer object representing the reward type
class RewardTypeDTO extends EnumDTO {
  ///Discount
  static const discount = RewardTypeDTO._internal('D');

  ///Cashback
  static const cashback = RewardTypeDTO._internal('C');

  ///Points
  static const points = RewardTypeDTO._internal('P');

  /// All the possible types for an offer
  static const List<RewardTypeDTO> values = [
    discount,
    cashback,
    points,
  ];

  const RewardTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [RewardTypeDTO] from a `String`.
  static RewardTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

///Data transfer object repersenting the reward type
class RewardScheduleDTO extends EnumDTO {
  ///Now (as soon as they're eligible for the reward)
  static const now = RewardScheduleDTO._internal('N');

  ///End of month
  static const endOfMonth = RewardScheduleDTO._internal('M');

  ///End of quarter
  static const endOfQuarter = RewardScheduleDTO._internal('Q');

  ///End of year
  static const endOfYear = RewardScheduleDTO._internal('Y');

  /// All the possible schedules for the reward
  static const List<RewardScheduleDTO> values = [
    now,
    endOfMonth,
    endOfQuarter,
    endOfYear,
  ];

  const RewardScheduleDTO._internal(String value) : super.internal(value);

  /// Creates a [RewardScheduleDTO] from a `String`.
  static RewardScheduleDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
