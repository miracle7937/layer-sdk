import '../../../../domain_layer/models.dart';
import '../../../dtos.dart';
import '../../../mappings.dart';

/// Extension for mapping the [LoyaltyPointsExchangeDTO]
extension LoyaltyPointsExchangeMapping on LoyaltyPointsExchangeDTO {
  /// Maps [LoyaltyPointsExchangeDTO] on [LoyaltyPointsExchange]
  LoyaltyPointsExchange toLoyaltyPointsExchange() => LoyaltyPointsExchange(
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
