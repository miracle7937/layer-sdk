import '../../errors.dart';
import '../../models.dart';
import '../dtos.dart';
import '../mappings.dart';

/// Mapper for [LoyaltyDTO] class
extension LoyaltyDTOMapping on LoyaltyDTO {
  /// Maps [LoyaltyDTO] to [Loyalty]
  Loyalty toLoyalty() {
    return Loyalty(
      id: loyaltyId!,
      created: created,
      updated: updated,
      status: (status ?? LoyaltyStatusDTO.deleted).toLoyaltyStatus(),
      balance: balance ?? 0,
      earned: earned ?? 0,
      burned: burned ?? 0,
      transferred: transferred ?? 0,
      adjusted: adjusted ?? 0,
      lastTransactionDate: lastTxn,
    );
  }
}

/// Extension for mapping the [LoyaltyStatusDTO]
extension LoyaltyStatusDTOMapping on LoyaltyStatusDTO {
  /// Maps [LoyaltyStatusDTO] to [LoyaltyStatus]
  LoyaltyStatus toLoyaltyStatus() {
    switch (this) {
      case LoyaltyStatusDTO.active:
        return LoyaltyStatus.active;

      case LoyaltyStatusDTO.deleted:
        return LoyaltyStatus.deleted;

      default:
        throw MappingException(from: LoyaltyStatusDTO, to: LoyaltyStatus);
    }
  }
}

/// Extension for mapping the [LoyaltyTransactionDTO]
extension LoyaltyTransactionMapper on LoyaltyTransactionDTO {
  /// Maps [LoyaltyTransactionDTO] to [LoyaltyTransaction]
  LoyaltyTransaction toLoyaltyTransaction() {
    return LoyaltyTransaction(
      id: transactionID ?? '',
      created: created,
      updated: updated,
      transactionType: (transactionType ?? LoyaltyTransactionTypeDTO.burn)
          .toLoyaltyTransactionType(),
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
}

///Extension for mapping the [LoyaltyTransactionTypeDTO]
extension LoyaltyTransactionTypeMapper on LoyaltyTransactionTypeDTO {
  ///Maps [LoyaltyTransactionTypeDTO] to [LoyaltyTransactionType]
  LoyaltyTransactionType toLoyaltyTransactionType() {
    switch (this) {
      case LoyaltyTransactionTypeDTO.adjust:
        return LoyaltyTransactionType.adjust;

      case LoyaltyTransactionTypeDTO.burn:
        return LoyaltyTransactionType.burn;

      case LoyaltyTransactionTypeDTO.earn:
        return LoyaltyTransactionType.earn;

      case LoyaltyTransactionTypeDTO.expire:
        return LoyaltyTransactionType.expire;

      case LoyaltyTransactionTypeDTO.transferred:
        return LoyaltyTransactionType.transfer;

      case LoyaltyTransactionTypeDTO.none:
        return LoyaltyTransactionType.none;

      default:
        throw MappingException(
          from: LoyaltyTransactionTypeDTO,
          to: LoyaltyTransactionType,
        );
    }
  }
}

///Extension for mapping the [LoyaltyTransactionType]
extension LoyaltyTransactionTypeDTOMapper on LoyaltyTransactionType {
  ///Maps [ LoyaltyTransactionType] to [LoyaltyTransactionTypeDTO]
  LoyaltyTransactionTypeDTO toLoyaltyTransactionTypeDTO() {
    switch (this) {
      case LoyaltyTransactionType.adjust:
        return LoyaltyTransactionTypeDTO.adjust;

      case LoyaltyTransactionType.burn:
        return LoyaltyTransactionTypeDTO.burn;

      case LoyaltyTransactionType.earn:
        return LoyaltyTransactionTypeDTO.earn;

      case LoyaltyTransactionType.expire:
        return LoyaltyTransactionTypeDTO.expire;

      case LoyaltyTransactionType.transfer:
        return LoyaltyTransactionTypeDTO.transferred;

      case LoyaltyTransactionType.none:
        return LoyaltyTransactionTypeDTO.none;

      default:
        throw MappingException(
          from: LoyaltyTransactionTypeDTO,
          to: LoyaltyTransactionType,
        );
    }
  }
}

/// Extension for mapping the [LoyaltyRateDTO]
extension LoyaltyRateMapping on LoyaltyRateDTO {
  /// Maps [LoyaltyRateDTO] on [LoyaltyRate]
  LoyaltyRate toRate() => LoyaltyRate(
        id: id!,
        rate: rate ?? 0.0,
        createdAt: createdAt,
        updatedAt: updatedAt,
        startDate: startDate,
      );
}

/// Extension for mapping the [LoyaltyExchangeDTO]
extension LoyaltyExchangeMapping on LoyaltyExchangeDTO {
  /// Maps [LoyaltyExchangeDTO] on [LoyaltyExchange]
  LoyaltyExchange toLoyaltyBurn() {
    return LoyaltyExchange(
      transactionId: transactionId ?? '',
      amount: amount ?? 0,
      transactionBalance: txnBalance ?? 0,
      balance: balance ?? 0,
      redemptionAmount: redemptionAmount ?? 0,
      exchangeRate: rate ?? 1,
      loyaltyId: loyaltyId,
      postedAt: tsPosted,
      accountId: accountId,
      redemptionAccount: redemptionAccount,
      otpId: otpId ?? '',
      secondFactor: secondFactor?.toSecondFactorType(),
      pin: pin ?? '',
      hardwareToken: hardwareToken ?? '',
      status: status?.toOTPStatus() ?? OTPStatus.unknown,
    );
  }
}

///Extension for mapping the [LoyaltyExpirationDTO]
extension LoyaltyExpirationMapping on LoyaltyExpirationDTO {
  ///Maps [LoyaltyExpirationDTO] into [LoyaltyExpiration]
  LoyaltyExpiration toLoyaltyExpiration() {
    return LoyaltyExpiration(
      amount: amount ?? 0,
    );
  }
}
