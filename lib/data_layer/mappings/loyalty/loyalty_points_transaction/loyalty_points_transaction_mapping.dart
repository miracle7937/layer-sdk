import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';
import '../../../errors.dart';

/// Extension for mapping the [LoyaltyPointsTransactionDTO]
extension LoyaltyPointsTransactionMapper on LoyaltyPointsTransactionDTO {
  /// Maps [LoyaltyPointsTransactionDTO] to [LoyaltyPointsTransaction]
  LoyaltyPointsTransaction toLoyaltyPointsTransaction() =>
      LoyaltyPointsTransaction(
        id: transactionID ?? '',
        created: created,
        updated: updated,
        transactionType:
            (transactionType ?? LoyaltyPointsTransactionTypeDTO.burn)
                .toLoyaltyPointsTransactionType(),
        loyaltyId: loyaltyId!,
        description: description ?? '',
        posted: posted,
        expiry: expiry,
        amount: amount ?? 0,
        balance: balance ?? 0,
        transactionBalance: transactionBalance ?? 0,
        redemptionAmount: redemptionAmount ?? 0,
        accountRedeemed: accountRedeemed ?? '',
        rate: rate?.toDouble() ?? 1.0,
      );
}

///Extension for mapping the [LoyaltyPointsTransactionTypeDTO]
extension LoyaltyPointsTransactionTypeMapper
    on LoyaltyPointsTransactionTypeDTO {
  ///Maps [LoyaltyPointsTransactionTypeDTO] to [LoyaltyPointsTransactionType]
  LoyaltyPointsTransactionType toLoyaltyPointsTransactionType() {
    switch (this) {
      case LoyaltyPointsTransactionTypeDTO.adjust:
        return LoyaltyPointsTransactionType.adjust;

      case LoyaltyPointsTransactionTypeDTO.burn:
        return LoyaltyPointsTransactionType.burn;

      case LoyaltyPointsTransactionTypeDTO.earn:
        return LoyaltyPointsTransactionType.earn;

      case LoyaltyPointsTransactionTypeDTO.expire:
        return LoyaltyPointsTransactionType.expire;

      case LoyaltyPointsTransactionTypeDTO.transferred:
        return LoyaltyPointsTransactionType.transfer;

      case LoyaltyPointsTransactionTypeDTO.none:
        return LoyaltyPointsTransactionType.none;

      default:
        throw MappingException(
          from: LoyaltyPointsTransactionTypeDTO,
          to: LoyaltyPointsTransactionType,
        );
    }
  }
}

///Extension for mapping the [LoyaltyPointsTransactionType]
extension LoyaltyPointsTransactionTypeDTOMapper
    on LoyaltyPointsTransactionType {
  ///Maps [LoyaltyPointsTransactionType] to [LoyaltyPointsTransactionTypeDTO]
  LoyaltyPointsTransactionTypeDTO toLoyaltyPointsTransactionTypeDTO() {
    switch (this) {
      case LoyaltyPointsTransactionType.adjust:
        return LoyaltyPointsTransactionTypeDTO.adjust;

      case LoyaltyPointsTransactionType.burn:
        return LoyaltyPointsTransactionTypeDTO.burn;

      case LoyaltyPointsTransactionType.earn:
        return LoyaltyPointsTransactionTypeDTO.earn;

      case LoyaltyPointsTransactionType.expire:
        return LoyaltyPointsTransactionTypeDTO.expire;

      case LoyaltyPointsTransactionType.transfer:
        return LoyaltyPointsTransactionTypeDTO.transferred;

      case LoyaltyPointsTransactionType.none:
        return LoyaltyPointsTransactionTypeDTO.none;

      default:
        throw MappingException(
          from: LoyaltyPointsTransactionType,
          to: LoyaltyPointsTransactionTypeDTO,
        );
    }
  }
}
