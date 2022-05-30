import 'package:collection/collection.dart';

import '../../../dtos.dart';
import '../../../helpers.dart';

///Data transfer object representing a rule for an offer
class OfferRuleDTO {
  ///Optional field that can be used to provide a pre-created rule
  int? id;

  ///The [RuleLogicDTO] for this rule
  RuleLogicDTO? logic;

  ///The rule decisions
  List<RuleDecisionDTO>? decisions;

  ///The reward for this rule
  RuleRewardDTO? reward;

  ///The card network for this rule
  List<CardNetworkDTO>? cardNetworkList;

  ///The list of [RuleActivityTypeDTO]
  List<RuleActivityTypeDTO>? activityTypes;

  ///The list of [RuleActivityDTO] for the rule
  List<RuleActivityDTO>? activities;

  ///The [RuleTypeDTO] for this rule
  RuleTypeDTO? type;

  ///Creates a new [OfferRuleDTO]
  OfferRuleDTO({
    this.id,
    this.logic,
    this.decisions,
    this.reward,
    this.cardNetworkList,
    this.activityTypes,
    this.activities,
    this.type,
  });

  ///Creates a [OfferRuleDTO] form a JSON object
  factory OfferRuleDTO.fromJson(Map<String, dynamic> json) => OfferRuleDTO(
        id: JsonParser.parseInt(json['rule_id']),
        logic: RuleLogicDTO.fromRaw(json['logic']),
        decisions: json['decision'] == null
            ? null
            : RuleDecisionDTO.fromJsonList(json['decision']),
        reward: json['reward'] == null
            ? null
            : RuleRewardDTO.fromJson(json['reward']),
        cardNetworkList: json['card_type'] == null
            ? []
            : json['card_type']
                .toString()
                .split('')
                .map(CardNetworkDTO.fromRaw)
                .whereNotNull()
                .toList(),
        activityTypes: json['activity_type'] == null
            ? []
            : json['activity_type']
                .toString()
                .split('')
                .map(RuleActivityTypeDTO.fromRaw)
                .whereNotNull()
                .toList(),
        activities: json['activity_types'] == null
            ? []
            : RuleActivityDTO.fromJsonList(json['activity_types']),
        type: RuleTypeDTO.fromRaw(json['rule_type']),
      );

  /// Creates a list of [OfferRuleDTO]s from the given JSON list.
  static List<OfferRuleDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(OfferRuleDTO.fromJson).toList();
}

///Data transfer object repersenting the logic for a rule
class RuleLogicDTO extends EnumDTO {
  /// All the rules must be completed in order to get the reward
  static const and = RuleLogicDTO._internal('and');

  /// Only one of the rules must be completed in order to get the reward
  static const or = RuleLogicDTO._internal('or');

  /// All the possible logic for a rule
  static const List<RuleLogicDTO> values = [
    and,
    or,
  ];

  const RuleLogicDTO._internal(String value) : super.internal(value);

  /// Creates a [RuleLogicDTO] from a `String`.
  static RuleLogicDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

///Data transfer object representing the activity types for a rule
///
/// When adding new values please note that the json mappings defined
/// in [RuleDecisionDTO.fromJson] and [OfferRuleDTO.fromJson] split the value
/// into single characters, so it will break if new raw values have
/// multiple characters.
class RuleActivityTypeDTO extends EnumDTO {
  /// Number of transactions
  static const numberOfTransactions = RuleActivityTypeDTO._internal('N');

  /// Card spend
  static const cardSpend = RuleActivityTypeDTO._internal('C');

  /// All the possible activity types for a rule
  static const List<RuleActivityTypeDTO> values = [
    numberOfTransactions,
    cardSpend,
  ];

  const RuleActivityTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [RuleActivityTypeDTO] from a `String`.
  static RuleActivityTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

///Data transfer object representing the possible types of a rule
class RuleTypeDTO extends EnumDTO {
  /// Reward (default)
  static const reward = RuleTypeDTO._internal('reward');

  /// Used to send demographic elements
  static const segmentation = RuleTypeDTO._internal('segmentation');

  /// All the possible types for a rule
  static const List<RuleTypeDTO> values = [
    reward,
    segmentation,
  ];

  const RuleTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [RuleTypeDTO] from a `String`.
  static RuleTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

///Data transfer object representing the possible card networks
class CardNetworkDTO extends EnumDTO {
  /// Mastercard
  static const mastercard = CardNetworkDTO._internal('M');

  /// VISA
  static const visa = CardNetworkDTO._internal('V');

  /// AmericanExpress
  static const americanExpress = CardNetworkDTO._internal('A');

  /// All the possible card networks
  static const List<CardNetworkDTO> values = [
    mastercard,
    visa,
    americanExpress
  ];

  const CardNetworkDTO._internal(String value) : super.internal(value);

  /// Creates a [CardNetworkDTO] from a `String`.
  static CardNetworkDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
