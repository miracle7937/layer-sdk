import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../../models.dart';

///The logic for a rule
enum RuleLogic {
  /// All the rules must be completed in order to get the reward
  and,

  /// Only one of the rules must be completed in order to get the reward
  or,
}

///The activity types for a rule
enum RuleActivityType {
  /// Number of transactions
  numberOfTransactions,

  /// Card spend
  cardSpend,
}

///The possible types of a rule
enum RuleType {
  /// Reward (default)
  reward,

  /// Used to send demographic elements
  segmentation,
}

///The possible card networks
enum CardNetwork {
  /// Mastercard
  mastercard,

  /// VISA
  visa,

  ///American Express
  americanExpress,
}

///Contains the data of an offer rule
class OfferRule extends Equatable {
  ///Optional field that can be used to provide a pre-created rule
  final int? id;

  ///The [RuleLogic] for this rule
  final RuleLogic logic;

  ///The rule decisions
  final UnmodifiableListView<RuleDecision> decisions;

  ///The reward for this rule
  final RuleReward? reward;

  ///The card network for this rule
  final UnmodifiableListView<CardNetwork> cardNetworkList;

  ///The list of [RuleActivityType]
  final UnmodifiableListView<RuleActivityType> activityTypes;

  ///The list of [RuleActivity] for the rule
  final UnmodifiableListView<RuleActivity> activities;

  ///The [RuleType] for this rule
  final RuleType? type;

  ///Creates a new [OfferRule]
  OfferRule({
    this.id,
    required this.logic,
    Iterable<RuleDecision>? decisions,
    this.reward,
    Iterable<CardNetwork>? cardNetworkList,
    Iterable<RuleActivityType>? activityTypes,
    Iterable<RuleActivity>? activities,
    this.type,
  })  : decisions = UnmodifiableListView(decisions ?? []),
        cardNetworkList = UnmodifiableListView(cardNetworkList ?? []),
        activityTypes = UnmodifiableListView(activityTypes ?? []),
        activities = UnmodifiableListView(activities ?? []);

  ///Creates a copy of this offer rule with different values
  OfferRule copyWith({
    int? id,
    RuleLogic? logic,
    Iterable<RuleDecision>? decisions,
    RuleReward? reward,
    Iterable<CardNetwork>? cardNetworkList,
    Iterable<RuleActivityType>? activityTypes,
    Iterable<RuleActivity>? activities,
    RuleType? type,
  }) =>
      OfferRule(
        id: id ?? this.id,
        logic: logic ?? this.logic,
        decisions: decisions ?? this.decisions,
        reward: reward ?? this.reward,
        cardNetworkList: cardNetworkList ?? this.cardNetworkList,
        activityTypes: activityTypes ?? this.activityTypes,
        activities: activities ?? this.activities,
        type: type ?? this.type,
      );

  @override
  List<Object?> get props => [
        id,
        logic,
        decisions,
        reward,
        cardNetworkList,
        activityTypes,
        activities,
        type,
      ];
}
