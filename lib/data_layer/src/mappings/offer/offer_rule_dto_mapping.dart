import 'package:collection/collection.dart';

import '../../../errors.dart';
import '../../../models.dart';
import '../../dtos.dart';

///Extension for mapping the [OfferRuleDTO]
extension OfferRuleDTOMapping on OfferRuleDTO {
  /// Maps an [OfferRuleDTO] into an [OfferRule].decisions
  ///
  /// Filters out the [decisions] with elements that are not supported
  /// by the [DecisionElement] enum.
  OfferRule toOfferRule() => OfferRule(
        id: id,
        logic: logic?.toRuleLogic() ?? RuleLogic.and,
        decisions: decisions
                ?.map((decision) => decision.toRuleDecision())
                .whereNotNull()
                .toList() ??
            [],
        reward: reward?.toRuleReward(),
        cardNetworkList:
            cardNetworkList?.map((network) => network.toCardNetwork()).toList(),
        activityTypes:
            activityTypes?.map((type) => type.toRuleActivityType()).toList() ??
                [],
        activities:
            activities?.map((activity) => activity.toRuleActivity()).toList() ??
                [],
        type: type?.toRuleType(),
      );
}

///Extension for mapping the [RuleLogicDTO]
extension RuleLogicDTOMapping on RuleLogicDTO {
  ///Maps a [RuleLogicDTO] into a [RuleLogic]
  RuleLogic toRuleLogic() {
    switch (this) {
      case RuleLogicDTO.and:
        return RuleLogic.and;

      case RuleLogicDTO.or:
        return RuleLogic.or;

      default:
        return RuleLogic.and;
    }
  }
}

/// Extension for mapping the [RuleDecisionDTO]
extension RuleDecisionDTOMapping on RuleDecisionDTO {
  /// Maps an [RuleDecisionDTO] into an [RuleDecision]
  ///
  /// Returns null if any of the required parameters are null.
  RuleDecision? toRuleDecision() {
    final decisionElement = element?.toDecisionElement();
    if ([decisionElement, operation].contains(null)) {
      return null;
    }
    return RuleDecision(
      element: decisionElement!,
      operation: operation!.toDecisionOperation(),
      values: values,
    );
  }
}

/// Extension for mapping the [DecisionElementDTO].
extension DecisionElementDTOMapping on DecisionElementDTO {
  /// Maps a [DecisionElementDTO] into a [DecisionElement].
  DecisionElement? toDecisionElement() {
    switch (this) {
      case DecisionElementDTO.cardSpend:
        return DecisionElement.cardSpend;

      case DecisionElementDTO.numberOfTransactions:
        return DecisionElement.numberOfTransactions;
    }
    return null;
  }
}

///Extension for mapping the [DecisionOperationDTO]
extension DecisionOperationDTOMapping on DecisionOperationDTO {
  ///Maps a [DecisionOperationDTO] into a [DecisionOperation]
  DecisionOperation toDecisionOperation() {
    switch (this) {
      case DecisionOperationDTO.equal:
        return DecisionOperation.equal;

      case DecisionOperationDTO.lessOrEqual:
        return DecisionOperation.lessOrEqual;

      case DecisionOperationDTO.greaterOrEqual:
        return DecisionOperation.greaterOrEqual;

      case DecisionOperationDTO.less:
        return DecisionOperation.less;

      case DecisionOperationDTO.greater:
        return DecisionOperation.greater;

      default:
        return DecisionOperation.equal;
    }
  }
}

///Extension for mapping the [RuleRewardDTO]
extension RuleRewardDTOMapping on RuleRewardDTO {
  ///Maps an [RuleRewardDTO] into an [RuleReward]
  RuleReward toRuleReward() => RuleReward(
        id: id,
        type: type?.toRewardType(),
        amount: amount,
        percentage: percentage,
        schedule: schedule?.toRewardSchedule() ?? RewardSchedule.now,
      );
}

///Extension for mapping the [RewardTypeDTO]
extension RewardTypeDTOMapping on RewardTypeDTO {
  ///Maps a [RewardTypeDTO] into a [RewardType]
  RewardType toRewardType() {
    switch (this) {
      case RewardTypeDTO.discount:
        return RewardType.discount;

      case RewardTypeDTO.cashback:
        return RewardType.cashback;

      case RewardTypeDTO.points:
        return RewardType.points;

      default:
        throw MappingException(
          from: RewardTypeDTO,
          to: RewardType,
        );
    }
  }
}

///Extension for [RewardType]
extension RewardTypeMapping on RewardType {
  ///Maps a [RewardType] into a code (For the provider)
  RewardTypeDTO toRewardTypeDTO() {
    switch (this) {
      case RewardType.discount:
        return RewardTypeDTO.discount;

      case RewardType.cashback:
        return RewardTypeDTO.cashback;

      case RewardType.points:
        return RewardTypeDTO.points;

      default:
        throw MappingException(
          from: RewardType,
          to: RewardTypeDTO,
        );
    }
  }
}

///Extension for mapping the [RewardScheduleDTO]
extension RewardScheduleDTOMapping on RewardScheduleDTO {
  ///Maps a [RewardScheduleDTO] into a [RewardSchedule]
  RewardSchedule toRewardSchedule() {
    switch (this) {
      case RewardScheduleDTO.now:
        return RewardSchedule.now;

      case RewardScheduleDTO.endOfMonth:
        return RewardSchedule.endOfMonth;

      case RewardScheduleDTO.endOfQuarter:
        return RewardSchedule.endOfQuarter;

      case RewardScheduleDTO.endOfYear:
        return RewardSchedule.endOfYear;

      default:
        return RewardSchedule.now;
    }
  }
}

///Extension for mapping the [RuleActivityTypeDTO]
extension RuleAcitivtyTypeDTOMapping on RuleActivityTypeDTO {
  ///Maps a [RuleActivityTypeDTO] into a [RuleActivityType]
  RuleActivityType toRuleActivityType() {
    switch (this) {
      case RuleActivityTypeDTO.numberOfTransactions:
        return RuleActivityType.numberOfTransactions;

      case RuleActivityTypeDTO.cardSpend:
        return RuleActivityType.cardSpend;

      default:
        throw MappingException(
          from: RuleActivityTypeDTO,
          to: RuleActivityType,
        );
    }
  }
}

///Extension for mapping the [RuleActivityDTO]
extension RuleActivtyMapping on RuleActivityDTO {
  ///Maps an [RuleActivityDTO] into an [RuleActivity]
  RuleActivity toRuleActivity() {
    if (type == null) {
      throw MappingException(
        from: RuleActivityDTO,
        to: RuleActivity,
        value: this,
        details: '`type` cannot be null',
      );
    }
    return RuleActivity(
      type: type!.toRuleActivityType(),
      total: total ?? 0,
      reached: reached ?? 0,
    );
  }
}

///Extension for mapping the [RuleTypeDTO]
extension RuleTypeDTOMapping on RuleTypeDTO {
  ///Maps a [RuleTypeDTO] into a [RuleType]
  RuleType toRuleType() {
    switch (this) {
      case RuleTypeDTO.reward:
        return RuleType.reward;

      case RuleTypeDTO.segmentation:
        return RuleType.segmentation;

      default:
        return RuleType.reward;
    }
  }
}

///Extension for mapping the [CardNetworkDTO]
extension CardNetworkDTOMapping on CardNetworkDTO {
  ///Maps a [CardNetworkDTO] into a [CardNetwork]
  CardNetwork toCardNetwork() {
    switch (this) {
      case CardNetworkDTO.mastercard:
        return CardNetwork.mastercard;

      case CardNetworkDTO.visa:
        return CardNetwork.visa;

      case CardNetworkDTO.americanExpress:
        return CardNetwork.americanExpress;

      default:
        throw MappingException(from: CardNetworkDTO, to: CardNetwork);
    }
  }
}
