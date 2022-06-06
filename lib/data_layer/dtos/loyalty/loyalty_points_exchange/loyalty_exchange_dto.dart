import '../../../dtos.dart';
import '../../../helpers/json_parser.dart';

/// Container for reading exchanged points on Loyalty
class LoyaltyPointsExchangeDTO {
  /// ID of the transaction after doing a burn/redeem
  final String? transactionId;

  /// Loyalty id
  final int? loyaltyId;

  /// Date when it was posted
  final DateTime? tsPosted;

  /// Amount Burned/redeemed/exchanged
  final int? amount;

  /// Account id
  final String? accountId;

  /// Balance of the transaction
  final int? txnBalance;

  /// Balance after the burn/redeem
  final int? balance;

  /// amount received
  final int? redemptionAmount;

  /// Account number that received the amount redeemed
  final String? redemptionAccount;

  /// Rate for exchanging the points
  final double? rate;

  /// OTP id
  final String? otpId;

  /// Second factor value
  final SecondFactorTypeDTO? secondFactor;

  /// PIN number factor value
  final String? pin;

  /// Hardware token value
  final String? hardwareToken;

  /// OTP status
  final OTPStatusDTO? status;

  /// Creates a [LoyaltyPointsExchangeDTO] instance
  LoyaltyPointsExchangeDTO({
    this.transactionId,
    this.loyaltyId,
    this.tsPosted,
    this.amount,
    this.accountId,
    this.txnBalance,
    this.balance,
    this.redemptionAmount,
    this.redemptionAccount,
    this.rate,
    this.otpId,
    this.secondFactor,
    this.pin,
    this.hardwareToken,
    this.status,
  });

  /// Creates a [LoyaltyPointsExchangeDTO] instance from a json map
  factory LoyaltyPointsExchangeDTO.fromJson(Map<String, dynamic> json) =>
      LoyaltyPointsExchangeDTO(
        transactionId: json['txn_id'],
        loyaltyId: JsonParser.parseInt(json['loyaltyId']),
        tsPosted: JsonParser.parseStringDate(json['tsPosted']),
        amount: JsonParser.parseInt(json['amount']),
        accountId: json['accountId'],
        txnBalance: JsonParser.parseInt(json['txnBalance']),
        balance: JsonParser.parseInt(json['balance']),
        redemptionAmount: JsonParser.parseInt(json['redemptionAmount']),
        redemptionAccount: json['redemptionAccount'],
        rate: JsonParser.parseDouble(json['rate']),
        otpId: json['otpId'],
        secondFactor: SecondFactorTypeDTO.fromRaw((json['second_factor'])),
        pin: json['pin'],
        hardwareToken: json['hardwareToken'],
        status: OTPStatusDTO.fromRaw(json['status']),
      );

  /// Returns a list of [LoyaltyPointsExchangeDTO] from a json list
  static Future<List<LoyaltyPointsExchangeDTO>> fromJsonList(
          List<Map<String, dynamic>> json) async =>
      json.map(LoyaltyPointsExchangeDTO.fromJson).toList(growable: false);
}
