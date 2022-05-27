import 'package:equatable/equatable.dart';
import '../../../models.dart';
import '../otp_status.dart';

/// Data class for exchanged loyalty points
class LoyaltyExchange extends Equatable {
  /// ID of the transaction
  final String? transactionId;

  /// Id loyalty id
  final int? loyaltyId;

  /// Date when it was posted
  final DateTime? postedAt;

  /// Amount of points redeemed
  final int amount;

  /// Account id
  final String? accountId;

  /// Balance of this transaction
  final int transactionBalance;

  /// Balance after the redeem
  final int balance;

  /// amount received
  final int redemptionAmount;

  /// Account number that will receive the redemption
  final String? redemptionAccount;

  /// Rate for exchanging the points
  final double exchangeRate;

  /// OTP id
  final String otpId;

  /// Second factor value
  final SecondFactorType? secondFactor;

  /// PIN number factor value
  final String pin;

  /// Hardware token value
  final String hardwareToken;

  /// OTP status
  final OTPStatus status;

  /// Create a [LoyaltyExchange] object
  const LoyaltyExchange({
    this.amount = 0,
    this.transactionBalance = 0,
    this.balance = 0,
    this.redemptionAmount = 0,
    this.exchangeRate = 0,
    this.otpId = '',
    this.secondFactor,
    this.pin = '',
    this.hardwareToken = '',
    this.status = OTPStatus.otp,
    this.loyaltyId,
    this.transactionId,
    this.postedAt,
    this.accountId,
    this.redemptionAccount,
  });

  /// Clone and return a new [LoyaltyExchange] object
  LoyaltyExchange copyWith({
    int? loyaltyId,
    String? transactionId,
    DateTime? postedAt,
    int? amount,
    String? accountId,
    int? transactionBalance,
    int? balance,
    int? redemptionAmount,
    String? redemptionAccount,
    double? exchangeRate,
    String? otpId,
    SecondFactorType? secondFactor,
    String? pin,
    String? hardwareToken,
    OTPStatus? status,
  }) {
    return LoyaltyExchange(
      loyaltyId: loyaltyId ?? this.loyaltyId,
      transactionId: transactionId ?? this.transactionId,
      postedAt: postedAt ?? this.postedAt,
      amount: amount ?? this.amount,
      accountId: accountId ?? this.accountId,
      transactionBalance: transactionBalance ?? this.transactionBalance,
      balance: balance ?? this.balance,
      redemptionAmount: redemptionAmount ?? this.redemptionAmount,
      redemptionAccount: redemptionAccount ?? this.redemptionAccount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      otpId: otpId ?? this.otpId,
      secondFactor: secondFactor ?? this.secondFactor,
      pin: pin ?? this.pin,
      hardwareToken: hardwareToken ?? this.hardwareToken,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        amount,
        transactionId,
        transactionBalance,
        balance,
        redemptionAmount,
        exchangeRate,
        loyaltyId,
        postedAt,
        accountId,
        redemptionAccount,
        otpId,
        secondFactor,
        pin,
        hardwareToken,
        status,
      ];
}
